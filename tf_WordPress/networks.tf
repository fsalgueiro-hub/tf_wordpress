# Create VPC in 
resource "aws_vpc" "vpc_wordpress" {
  provider             = aws.region-wordpress
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "wordpress-vpc"
  }
}

# Create IGW in wordpress region
resource "aws_internet_gateway" "igw" {
  provider = aws.region-wordpress
  vpc_id   = aws_vpc.vpc_wordpress.id
}

# Get all available AZs' in VPC for wordpress region
data "aws_availability_zones" "azs" {
  provider = aws.region-wordpress
  state    = "available"
}

# Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-wordpress
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_wordpress.id
  cidr_block        = "10.0.1.0/24"
}

# Create subnet # 2 in us-east-1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-wordpress
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_wordpress.id
  cidr_block        = "10.0.2.0/24"
}

# Create route table in us-east-1
resource "aws_route_table" "internet_route" {
  provider = aws.region-wordpress
  vpc_id   = aws_vpc.vpc_wordpress.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Wordpress-Region-RT"
  }
}

# Overwrite default route table of VPC(Master) with our route table entries
resource "aws_main_route_table_association" "set-wordpress-default-rt-assoc" {
  provider       = aws.region-wordpress
  vpc_id         = aws_vpc.vpc_wordpress.id
  route_table_id = aws_route_table.internet_route.id
}