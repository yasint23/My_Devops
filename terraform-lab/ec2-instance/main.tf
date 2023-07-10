provider "aws" {
    region     = "us-west-2"

}

resource "aws_security_group" "web-server" {

    name        = "web-server"
    description = "Allow incoming HTTP Connections"
    
    ingress {

        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

   }

    egress {

        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

}

resource "aws_instance" "web-server" {

    ami = "ami-02e136e904f3da870"

    instance_type = "t2.micro"

    key_name = "yasinkey"

    security_groups = ["${aws_security_group.web-server.name}"]

 
    user_data = <<-EOF

    #!/bin/bash

    sudo su

    yum update -y

    yum install httpd -y

    systemctl start httpd

    systemctl enable httpd

    echo "<html><h1> Welcome to DevOps Yasin Blog Page. Happy Learning... </h1></html>" >> /var/www/html/index.html

    EOF

 
    tags = {

        Name = "web_instance"

    }

}