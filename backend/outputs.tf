output "s3_bucket_name" {
  value = aws_s3_bucket.this.id
}

output "iam_role_arn" {
  value = module.aws_oidc_github.iam_role_arn
}
