provider "aws" {
    region     = "${var.region}"
#    access_key = "${var.access_key}"
#    secret_key = "${var.secret_key}"
}

################## Creating an EKS Cluster ##################
resource "aws_eks_cluster" "cluster" {
  name     = "my-cluster"
  role_arn = "Enter your Role ARN Here"

  vpc_config {
    subnet_ids = ["subnet-ID-1", "subnet-ID-2"]
  }
}