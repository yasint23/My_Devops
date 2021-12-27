
variable "ec2_type" {
  default = "t2.micro"
}

variable "tf-tags" {
  type    = list(string)
  default = ["Terraform First Instance", "Terraform Second Instance"]
}