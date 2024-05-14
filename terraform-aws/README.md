# Demo AWS Environment Setup

Configuration in this directory creates a VPC with Public and Private Subnets, a Bastion host, an AWS EKS cluster with EKS Managed Node Groups:

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.40 |

## Usage

To setup this demo environment, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```