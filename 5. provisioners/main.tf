provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_key_pair" "example" {
  key_name   = "terraform-demo-phani" 
  public_key = file("../my-key.pub") 
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "ec2-sg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    key_name      = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.ec2-sg.id]
    subnet_id              = aws_subnet.sub1.id

    tags = {
        "Name" : "Example Instance"
    }

    connection {
        type        = "ssh"
        user        = "ec2-user"  # Replace with the appropriate username for your EC2 instance
        private_key = file("../my-key")  # Replace with the path to your private key
        host        = self.public_ip
    }

    provisioner "file" {
      source = "./app.py"
      destination = "/home/ec2-user/app.py"
    }

    provisioner "remote-exec" {
      inline = [ 
         "echo 'Hello from the remote instance'",
  "sudo yum update -y || sudo dnf update -y",
  "sudo yum install -y python3-pip python3-venv || sudo dnf install -y python3-pip python3-venv",
  "cd /home/ec2-user",
  "python3 -m venv venv",
  "source venv/bin/activate",
  "pip install flask",
  "nohup python app.py > app.log 2>&1 &" 
       ]
    }
}

