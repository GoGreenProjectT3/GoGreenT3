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
resource "aws_subnet" "private_subnet1a" {
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
resource "aws_eip" "gogreen" {
  vpc      = true
}


# NAT Gateway
resource "aws_nat_gateway" "nat_gateway1" {
  connectivity_type = "public"
  allocation_id = aws_eip.gogreen.id

  subnet_id         = aws_subnet.public_us_west_1a.id

  tags = {
    Name = "NAT-GW1"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "nat_gateway2" {
  connectivity_type = "public"
  allocation_id = aws_eip.gogreen2.id

  subnet_id         = aws_subnet.public_us_west_1c.id

  tags = {
    Name = "NAT-GW2"
  }
}

# Creating Private Route Table1
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  tags = {
    Name = "Private-Table1"
  }
}
# Creating Private Route Table2
resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway2.id
  }

  tags = {
    Name = "Private-Table2"
  }
}
# Route Table association with Private Subnet
resource "aws_route_table_association" "b" {
  subnet_id      = element(aws_subnet.private_subnet1a.*.id, count.index)
  count          = length(var.subnet_cidrs_private_1a)
  route_table_id = aws_route_table.private_route_table1.id
}
# Route Table association with Private Subnet
resource "aws_route_table_association" "c" {
  subnet_id      = element(aws_subnet.private_subnet1c.*.id, count.index)
  count          = length(var.subnet_cidrs_private_1c)
  route_table_id = aws_route_table.private_route_table2.id
}