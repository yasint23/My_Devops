#!/bin/bash
yum update -y
yum install httpd -y
chmod -R 777 /var/www/html
cd /var/www/html
wget https://raw.githubusercontent.com/Nec2005/My_AWS_Course_Projects/main/aws/Project-101-kittens-carousel-static-website-ec2/static-web/index.html 
wget https://raw.githubusercontent.com/Nec2005/My_AWS_Course_Projects/main/aws/Project-101-kittens-carousel-static-website-ec2/static-web/cat0.jpg
wget https://raw.githubusercontent.com/Nec2005/My_AWS_Course_Projects/main/aws/Project-101-kittens-carousel-static-website-ec2/static-web/cat1.jpg
wget https://raw.githubusercontent.com/Nec2005/My_AWS_Course_Projects/main/aws/Project-101-kittens-carousel-static-website-ec2/static-web/cat2.jpg
wget https://raw.githubusercontent.com/Nec2005/My_AWS_Course_Projects/main/aws/Project-101-kittens-carousel-static-website-ec2/static-web/cat3.png
systemctl start httpd
systemctl enable httpd