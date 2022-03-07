#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
yum install git -y
<<<<<<< HEAD
TOKEN="xxxxxxxxxxxxxxxxxxxxxxx"
=======
TOKEN="xxxxxxxxxxxxx"
>>>>>>> 5a3c871ebf81908833e33cb3fbe37acc3bad6b71
cd /home/ec2-user && git clone https://$TOKEN@github.com/TylerCounter/phonebook.git
python3 /home/ec2-user/phonebook/phonebook-app.py
