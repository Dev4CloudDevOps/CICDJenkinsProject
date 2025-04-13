# state.tf
terraform {
  backend "s3" {
    bucket = "terraform-dummy-s3-bucket-1"
    key    = "terraformProjectFiles/terraform.tfstate"
    region = "us-east-1"
  }
}