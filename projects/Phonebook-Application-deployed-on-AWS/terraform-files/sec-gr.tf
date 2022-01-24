

resource "aws_security_group" "alb-sg" {
  name   = "ALBSecurityGroup"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "TF_ALBSecurityGroup"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}


resource "aws_security_group" "server-sg" {
  name   = "WebserverSecurityGroup"
  vpc_id = data.aws_vpc.default.id
  tags = {
    "Name" = "WebserverSecurityGroup"
  }
  ingress {
    security_groups = [aws_security_group.alb-sg.id]
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}


resource "aws_security_group" "db-sg" {
  name   = "RDSSecurityGroup"
  vpc_id = data.aws_vpc.default.id
  tags = {
    "Name" = "RDSSecurityGroup"
  }
  ingress {
    security_groups = [aws_security_group.server-sg.id]
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}