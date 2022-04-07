#
# Providing an AWS infrastructure:
#       - IAM roles & policy attachments
#       - Security Groups
#       - VPC
#       - EC2 Subnets in Multi-AZs
#       - Database Subnet
#       - RDS Postgres
#       - Using Secure Password in SSM Parameter Store
#       - ECS services Which Serve Application
#       - ASG with Launch Configuration
#       - Amazon Certificate for Secure Connection
#       - ALB with HTTPS redirect
#       - ALB Hosted Zone attachment
#
# Developed by maksmore 2022.04
#--------------------------------------------------------------------------------------|

provider "aws" {}

# -------------------------------------------------------------------------------------|

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.app_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.app_name
  }
  depends_on = [aws_vpc.main]
}

resource "aws_subnet" "ec2_subnet" {
  count                   = length(var.ec2_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.ec2_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "EC2-Subnet-${var.app_name}"
  }
}

resource "aws_subnet" "database_subnet" {
  count             = length(var.ec2_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.database_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Database-Subnet-${var.app_name}"
  }
}

resource "aws_route_table" "ec2_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "ec2" {
  count          = length(aws_subnet.ec2_subnet)
  subnet_id      = aws_subnet.ec2_subnet[count.index].id
  route_table_id = aws_route_table.ec2_route.id

}

resource "aws_route_table" "database_route" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Database-Route-Table"
  }
}

resource "aws_route_table_association" "database" {
  count          = length(aws_subnet.database_subnet)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database_route.id
}



# ----------------------------------------------------------------------------------------|








