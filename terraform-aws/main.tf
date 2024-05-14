provider "aws" {
  region = "us-west-2"
}

# terraform {
#   backend "s3" {
#     bucket = "demo-terraform01"
#     key = "dev/terraform.tfstate"
#     region = "us-west-2"
#   }
# }

terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

locals {
  name   = "demo"
  region = "us-west-2"

  tags = {
    Environment    = "demo"
    Terraform      = true
  }

  s3_bucket_name            = "demo-vpc-logs010"
  cloudwatch_log_group_name = "demo-vpc-cloudwatch-logs"
}