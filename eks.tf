module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "eks-${random_string.suffix.result}"
  cluster_version = "1.20"

  vpc_id  = module.vpc.vpc_id
  subnets = [module.vpc.private_subnets[0], module.vpc.public_subnets[1]]

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_security_group_id = aws_security_group.custom_sg.id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.micro"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.custom_sg.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.custom_sg.id]
      asg_desired_capacity          = 1
    }
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = "vpc-${random_string.suffix.result}"
  cidr                 = "10.0.0.0/16"
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

resource "aws_security_group" "custom_sg" {
  name = "sg-${random_string.suffix.result}"
  ingress {
    from_port   = var.custom_port
    to_port     = var.custom_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}