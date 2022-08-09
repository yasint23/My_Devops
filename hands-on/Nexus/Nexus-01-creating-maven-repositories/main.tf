terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "nexus-ec2" {
  ami           = "ami-0cff7528ff583bf9a" 
  instance_type = "t2.medium"
  key_name      = "yasin" # write your pem file without .pem extension>
  security_groups = ["nexus-sg"]
  tags = {
    "Name" = "nexus-ec2"
  }
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_security_group" "nexus-sg" {
  name        = "nexus-sg"
  description = "nexus security group"
  tags = {
    Name = "nexus-sg"
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
  ingress {
    from_port   = 8081
    protocol    = "tcp"
    to_port     = 8081
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}