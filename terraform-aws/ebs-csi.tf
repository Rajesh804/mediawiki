
resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  namespace   = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.17.1"

  set {
    name  = "controller.serviceAccount.name"
    value = "ebs-csi-controller"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${module.ebs_csi_irsa_role.iam_role_arn}"
  }

  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${module.ebs_csi_irsa_role.iam_role_arn}"
  }

  set {
    name  = "node.serviceAccount.create"
    value = "false"
  }  

  set {
    name  = "node.serviceAccount.name"
    value = "ebs-csi-controller"
  }  

}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi-${local.eks_cluster_name}"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller"]
    }
  }

  tags = local.tags
}