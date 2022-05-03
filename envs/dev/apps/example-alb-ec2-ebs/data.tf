data "aws_caller_identity" "current" {}

data "aws_vpc" "this" {
  default = true
}

data "aws_ami" "this" {
  most_recent = true
  name_regex  = "^ubuntu"
  owners      = ["amazon"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnets" "instance" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "availability-zone"
    values = [local.availability_zone]
  }
}

data "aws_subnets" "alb" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}
