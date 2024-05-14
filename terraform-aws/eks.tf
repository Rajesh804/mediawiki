data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.eks_cluster_version}-v*"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = local.eks_cluster_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = [
                  "117.247.19.45/32", #My static IP
                  "0.0.0.0/0"
                ]

  cluster_enabled_log_types = [
                                "audit",
                                "api",
                                "authenticator",
                                "controllerManager",
                                "scheduler"
                              ]   

  cluster_addons = {
    aws-ebs-csi-driver = {
      addon_version     = "v1.30.0-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
      service_account_role_arn = "${module.ebs_csi_irsa_role.iam_role_arn}"
    }    
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id                   = module.vpc.vpc_id 
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    demo = {
      min_size     = 2
      max_size     = 3
      desired_size = 2
      disk_size = 100
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      # remote_access = {
      #   ec2_ssh_key               = "demo"
      #   source_security_group_ids = [aws_security_group.office_only.id]
      # }      
    }
  }

  enable_cluster_creator_admin_permissions = "true"

  tags = {
    Environment = "demo"
    Terraform   = "true"
  }
}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.0"
  role_name             = "ebs-csi-${local.eks_cluster_name}"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = local.tags
}