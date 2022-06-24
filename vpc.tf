resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "public_us_west_1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "Public Subnet us-west-1a"
  }
}

resource "aws_subnet" "public_us_west_1c" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "Public Subnet us-west-1c"
  }
}


resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "main_vpc_public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_igw.id
  }

  tags = {
    Name = "Public Subnets Route Table for My VPC"
  }
}

resource "aws_route_table_association" "main_vpc_us_west_1a_public" {
  subnet_id      = aws_subnet.public_us_west_1a.id
  route_table_id = aws_route_table.main_vpc_public.id
}
resource "aws_route_table_association" "main_vpc_us_west_1b_public" {
  subnet_id      = aws_subnet.public_us_west_1c.id
  route_table_id = aws_route_table.main_vpc_public.id
}

# Create Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.subnet_cidrs_private_1a)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.subnet_cidrs_private_1a[count.index]
  availability_zone = "us-west-1a"

  tags = {
    Name = "Private-Subnet"
  }
}
# Create Private Subnet
resource "aws_subnet" "private_subnet_1c" {
  count             = length(var.subnet_cidrs_private_1c)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.subnet_cidrs_private_1c[count.index]
  availability_zone = "us-west-1c"

  tags = {
    Name = "Private-Subnet"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public_us_west_1a.id

  tags = {
    Name = "NAT-GW1"
  }
}

# Creating Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  tags = {
    Name = "Private-Table"
  }
}
# Route Table association with Private Subnet
resource "aws_route_table_association" "b" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  count          = length(var.subnet_cidrs_private_1a)
  route_table_id = aws_route_table.private_route_table.id
}
