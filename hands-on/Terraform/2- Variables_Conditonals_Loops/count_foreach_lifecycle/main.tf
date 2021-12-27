provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

resource "aws_instance" "web" {
  #count         = 2
  for_each = {
    prod = "t2.micro"
    dev = "t2.large" 
  }

  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  key_name      = "firstkey" # write your pem file without .pem extension>
  tags = {
    #Name = "Test ${count.index}"
    Name = "Test ${each.key}"
  }
}

output "instance" {
  #value = aws_instance.web[*].public_ip
  value = aws_instance.web["prod"].public_ip
}

lifecycle {
  #create_before_destroy = true 
  #prevent_destroy = true 
  #ignore_changes = [tags]
}