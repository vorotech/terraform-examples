// While running the initial terraform apply, this section should be commented.
// But once S3 bucket created, the terraform backend configuration should be updated
// to store its state at the remote bucket storage. 
terraform {
  backend "s3" {
    bucket         = "tfstate-3dda10e9-d16b-595f-bc60-e7efd8ced837"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
  }
}