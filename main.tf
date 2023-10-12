# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet co1
resource "aws_subnet" "public_subnet_co1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_co1_cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names [0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet_co1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_co2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_co2_cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names [1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet_co2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "public_route_table"
  }
}

# associate public subnet co2 to "public route table"
resource "aws_route_table_association" "public_subnet_co1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_co1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet co2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_co2.id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnet co1
resource "aws_subnet" "private_app_subnet_co1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_co1_cidr_block
  availability_zone        = data.aws_availability_zones.available_zones.names [0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_app_subnet_co1"
  }
}

# create private app subnet co2
resource "aws_subnet" "private_app_subnet_co2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_co2_cidr_block
  availability_zone        = data.aws_availability_zones.available_zones.names [1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_app_subnet_co2"
  }
}

# create private data subnet az1
resource "aws_subnet" "private_data_subnet_co1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_co1_cidr_block
  availability_zone        = data.aws_availability_zones.available_zones.names [0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_data_subnet_co1"
  }
}

# create private data subnet az2
resource "aws_subnet" "private_data_subnet_co2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_co2_cidr_block
  availability_zone        = data.aws_availability_zones.available_zones.names [1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_data_subnet_co2"
  }
}