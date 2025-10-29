provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"

    tags = {
        "Name" : "Example Instance"
    }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "phani-s3-backend-state"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
