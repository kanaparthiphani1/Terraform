variable "region" {
  type        = string
  description = "Region for the aws resources"
  default     = "us-east-1"
}

variable "ami" {
  type        = string
  description = "AMI for the aws ec2 resources"
  default     = "ami-07860a2d7eb515d9a"
}

variable "instance_type" {
  type        = string
  description = "instance_type for the aws ec2 resources"
  default     = "t3.micro"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "first_instance" {
  ami           = "ami-07860a2d7eb515d9a"
  instance_type = "t3.micro"
}