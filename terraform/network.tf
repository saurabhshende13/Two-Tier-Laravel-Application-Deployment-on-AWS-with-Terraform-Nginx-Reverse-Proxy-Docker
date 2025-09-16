########################################
# VPC + Networking
########################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.project}-vpc" }
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project}-igw" }
}

# Public Subnet (Nginx + External LB)
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet[0]
  availability_zone       = var.az[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project}-public" }
}

# Public Subnet (Nginx + External LB)
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet[1]
  availability_zone       = var.az[1]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project}-public" }
}


# Private Subnet (App ASG + Internal LB)
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet[0]
  availability_zone = var.az[0]
  tags              = { Name = "${var.project}-private" }
}

# Private Subnet (App ASG + Internal LB)
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet[1]
  availability_zone = var.az[1]
  tags              = { Name = "${var.project}-private" }
}

# NAT Gateway (to give Internet to private subnet)
resource "aws_eip" "nat" {
  # 
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id
  tags          = { Name = "${var.project}-natgw" }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = { Name = "${var.project}-private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}
