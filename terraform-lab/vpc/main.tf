provider "aws" {
     region     = "us-west-2"
}
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.vpc.id
}
resource "aws_route" "route" {
    route_table_id         = aws_vpc.vpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.gateway.id
}
data "aws_availability_zones" "available" {}

resource "aws_subnet" "main" {
   count                   = length(data.aws_availability_zones.available.names)
   vpc_id                  = aws_vpc.vpc.id
   cidr_block              = "10.0.${count.index}.0/24"
   map_public_ip_on_launch = true
   availability_zone       = element(data.aws_availability_zones.available.names, count.index)
}