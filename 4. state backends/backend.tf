terraform {
  backend "s3" {
    bucket         = "phani-s3-backend-state" # change this
    key            = "phani/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}