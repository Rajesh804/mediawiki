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
  version = "~> 19.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.28"

  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = [
                  "117.247.19.45/32" #My static IP
                ]

  cluster_enabled_log_types = [
                                "audit",
                                "api",
                                "authenticator",
                                "controllerManager",
                                "scheduler"
                              ]   

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id 
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true
    disk_size = 200
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    demo-ng01 = {
      name            = "demo-eks-ng01"
      use_name_prefix = false

      subnet_ids = module.vpc.private_subnets

      min_size     = 3
      max_size     = 6
      desired_size = 3

      ami_id                     = data.aws_ami.eks_default.image_id

      capacity_type        = "SPOT"
      force_update_version = true
      instance_types       = ["m4.xlarge", "m5.xlarge", "m5d.xlarge", "m5a.xlarge"]
      labels = {
        Name = "demo-eks"
      }

      description = "EKS managed node group for Demo Environment"

      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 200
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
    }

  }

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::012345678901:role/jenkins-demo-eks" #Assuming we have a Jenkins Cluser running in another EKS Cluster
      username = "{{SessionName}}"
      groups   = ["system:masters"]
    },    
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::012345678901:user/rajesh.reddy"
      username = "rajesh.reddy"
      groups   = ["system:masters"]
    },
  ]

  tags = {
    Environment = "demo"
    Terraform   = "true"
  }
}