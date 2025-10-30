provider "aws" {
    region = "us-east-1"
}

module "aws_module_instance" {
  source = "./modules/ec2_instance"
  ami_value           = var.ami_value
  instance_type_value = lookup(var.instance_type_value, terraform.workspace, "t3.micro")
}