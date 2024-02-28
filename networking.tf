#VPC creation
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = true
  tags = {
    Name = var.project_name
  }
}

resource "aws_subnet" "subnet" {
  count             = length(var.subnet_names)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block[count.index]
  availability_zone = element(data.aws_availability_zones.avz.names, count.index)
  tags              = { name = "${var.subnet_names[count.index]}" }

  depends_on = [aws_vpc.vpc]
}


resource "aws_internet_gateway" "gw" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]

}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet[0].id

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = var.vpc_cidr
    gateway_id = var.local_access
  }
  route {
    cidr_block = var.public_access
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = var.vpc_cidr
    gateway_id = var.local_access
  }
  route {
    cidr_block = var.public_access
    gateway_id = aws_nat_gateway.nat_gw.id
  }
}
resource "aws_route_table_association" "public_route_a" {

  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public_route_b" {

  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private_route_a" {
  subnet_id      = aws_subnet.subnet[2].id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "private_route_b" {

  subnet_id      = aws_subnet.subnet[3].id
  route_table_id = aws_route_table.private-rt.id
}