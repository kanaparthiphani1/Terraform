provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "xxxxxxxxxxxxxx"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "xxxxxxxxxxxxxxxxx"
      secret_id = "xxxxxxxxxxxxxxxxxxx"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

# resource "aws_instance" "example" {
#   ami           = "ami-0360c520857e3138f"
#   instance_type = "t3.micro"

#   tags = {
#     Name = "test"
#     Secret = data.vault_kv_secret_v2.example.data["foo"]
#   }
# }