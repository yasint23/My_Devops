terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
resource "aws_instance" "tf-ec2" {
  ami             = data.aws_ami.tf_ami.id
  instance_type   = var.ec2_type
  #user_data       = file("userdata.sh")
  key_name        = "firstkey"
  security_groups = ["tf-sg"]
  count           = 2
  tags = {
    Name = element(var.tf-tags, count.index)
  }


  provisioner "local-exec" {
    command = "echo http://${self.public_ip} > public_ip.txt"
  }

  provisioner "local-exec" {
    command = "echo http://${self.private_ip} > private_ip.txt"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("firstkey.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo chmod -R 777 /var/www/html",
      "sudo echo 'Hello World' > /var/www/html/index.html"   #This method will take more time, defining userdata.sh method in resource best practice
    ]
  }
}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-sg"
  tags = {
    Name = "tf-sg"
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

output "instance" {
  value = aws_instance.tf-ec2.*.public_ip
}