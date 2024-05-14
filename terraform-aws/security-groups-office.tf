resource "aws_security_group" "office_only" {
  name = "demo-${local.env}-office-only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
                      "117.247.19.45/32"
                  ]
    description = "Demo Office Network Access"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
                      "117.247.19.45/32"
                  ]
    description = "Demo Office SSH Access"
  }

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"
    cidr_blocks = [
                      "117.247.19.45/32"
                  ]
    description = "Demo Office RDP Access"
  }

  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "demo-${local.env}-office-only"
    Environment = "${local.env}"
  }

}
