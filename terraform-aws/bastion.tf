module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "5.1.0"

  name = "demo-bastion"
  key_name                    = "demo"
  instance_type               = "t2.micro"
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = ["${aws_security_group.office_only.id}"]
  associate_public_ip_address = true

  maintenance_options = {
    auto_recovery = "default"
  }

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    SSM = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  }  

  tags = local.tags
}
