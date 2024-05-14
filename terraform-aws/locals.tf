data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals{
  vpc_cidr      =  "10.220.0.0/16"
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  env          = "dev"

  # EKS Variables
  eks_cluster_name = "demo-eks01"
  eks_cluster_version= "1.29"

}