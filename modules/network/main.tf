data "aws_availability_zones" "azs" {}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr
  tags = {
    Name = "${var.main_vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.azs.names[0]
  tags = {
    Name = "${var.main_vpc_name} PublicSubnet"
  }
}

resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.main_vpc_name} IGW"
  }
}

resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  route {
    cidr_block = var.all_addresses
    gateway_id = aws_internet_gateway.main_vpc_igw.id
  }
  tags = {
    Name = "${var.main_vpc_name} default RT"
  }
}
