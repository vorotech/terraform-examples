terraform {
  required_version = "1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_uuid" "bucket_postfix" {}

locals {
  bucket_name = "tfstate-${random_uuid.bucket_postfix.result}"
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name     = "terraform-state-locking"
  hash_key = "LockID"

  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = false
  }

  tags = {
    Name = "terraform-state-locking"
    app  = "terraform"
    env  = "prod"
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = false

  tags = {
    Name = local.bucket_name
    app  = "terraform"
    env  = "prod"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.bucket
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

module "aws_oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "0.6.1"

  attach_admin_policy  = true
  create_oidc_provider = true
  github_repositories  = ["vorotech/terraform-examples"]
  iam_role_name        = "github-terraform"
  iam_role_path        = "/deployment-role/"

  tags = {
    "app" = "terraform"
  }
}
