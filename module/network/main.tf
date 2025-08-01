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

#Create IGW
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
    Name = "terra-pub-subnet"
  } 
}

# Create public routetable
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

#Create routetable associate
resource "aws_route_table_association" "terra-rt-associate" {
  count          = 2
  subnet_id      = aws_subnet.terra-pub-subnet.*.id[count.index]
  route_table_id = aws_route_table.terra-pub-route.id
}

