provider "aws" {
  version = "~> 4.0"
  region  = "us-east-2"
}
resource "aws_vpc" "test_vpc" {
 cidr_block = "10.0.0.0/16"
 instance_tenancy = "default"
 enable_dns_support = true
 enable_dns_hostnames = true
 
 tags = {
   Name = "Project-VPC"
 }
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.test_vpc.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.test_vpc.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_internet_gateway" "Igw" {
 vpc_id = aws_vpc.test_vpc.id
 
 tags = {
   Name = "Project VPC IG"
 }
}

resource "aws_route_table" "route_table" {
 vpc_id = aws_vpc.test_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.Igw.id
 }
 
 tags = {
   Name = "Route-Table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.route_table.id
}
