terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_security_group" "ec2-sec-gr" {
  name = "ec2-sec-gr"
  tags = {
    Name = "ec2-sec-group"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_linux" {
  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  key_name      = "yasin"    # write your pem file without .pem extension>
  security_groups = ["ec2-sec-gr"]

  tags = {
    "Name" = "my-linux"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "yasin-tf-test-bucket"
  acl    = "private"
}

output "tf_example_public_ip" {
  value = aws_instance.my_linux.public_ip
}


