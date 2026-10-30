terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "portfolio_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "terraform-portfolio-vpc"
    Project = "Cloud-Engineering-Portfolio"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.portfolio_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "terraform-public-subnet"
    Project = "Cloud-Engineering-Portfolio"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.portfolio_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name    = "terraform-private-subnet"
    Project = "Cloud-Engineering-Portfolio"
  }
}
resource "aws_internet_gateway" "portfolio_igw" {
  vpc_id = aws_vpc.portfolio_vpc.id

  tags = {
    Name    = "terraform-portfolio-igw"
    Project = "Cloud-Engineering-Portfolio"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.portfolio_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.portfolio_igw.id
  }

  tags = {
    Name    = "terraform-public-route-table"
    Project = "Cloud-Engineering-Portfolio"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
