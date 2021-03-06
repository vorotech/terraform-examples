// Code generated by tfgen. DO NOT EDIT.

terraform {
  required_version = "1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }

  backend "s3" {
    bucket         = "tfstate-3dda10e9-d16b-595f-bc60-e7efd8ced837"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
    key            = "dev/apps/example-alb-ec2-ebs/terraform.tfstate"
    region         = "us-east-1"
  }
}
