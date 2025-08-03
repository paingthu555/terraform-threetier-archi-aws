# Create VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Create IGW
resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terra-igw"
  }
}

# Create public subnet
resource "aws_subnet" "terra-pub-subnet" {
  count      = 2
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = element(["172.16.1.0/24", "172.16.2.0/24"], count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "terra-pub-subnet-${count.index}"
  } 
}

# Create public route table
resource "aws_route_table" "terra-pub-route" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }

  tags = {
    Name = "terra-pub-rt"
  }
}

# Create routetable associate for public web tier 
resource "aws_route_table_association" "terra-pub-rt-associate" {
  count          = 2
  subnet_id      = aws_subnet.terra-pub-subnet.*.id[count.index]
  route_table_id = aws_route_table.terra-pub-route.id
}

# Create EIP and NatGW
resource "aws_eip" "terra-nat-eip" {
    domain   = "vpc"
}

resource "aws_nat_gateway" "terra-ngw" {
  allocation_id     = aws_eip.terra-nat-eip.id
  subnet_id         = aws_subnet.terra-pub-subnet[1].id
}

# Create private subnet for app tier
resource "aws_subnet" "terra-priv-subnet" {
  count      = 2
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = element(["172.16.10.0/24", "172.16.20.0/24"], count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "terra-priv-subnet-${count.index}"
  } 
}

# Create private route table for app tier
resource "aws_route_table" "terra-priv-rt" {
  vpc_id = aws_vpc.terraform-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terra-ngw.id
  }
  tags = {
    Name = "terra-priv-rt"
  }
}

# Create private route table association for app tier
resource "aws_route_table_association" "terra-priv-rt-associate" {
  count          = 2
  subnet_id      = aws_subnet.terra-priv-subnet.*.id[count.index]
  route_table_id = aws_route_table.terra-priv-rt.id
}


# Create DB subnet and subnet group
resource "aws_subnet" "terra-db-priv-subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = element(["172.16.5.0/24", "172.16.6.0/24"], count.index)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "terra-db-priv-subnet-${count.index}"
  }
}

resource "aws_db_subnet_group" "terra-db-subnet-gp" {
  count      = var.db_subnet_gp == true ? 1 : 0
  name       = "terra-db-subnet-gp"
  subnet_ids = [aws_subnet.terra-db-priv-subnet[0].id, aws_subnet.terra-db-priv-subnet[1].id]

  tags = {
    Name = "terra-db-subnet-gp"
  }
}