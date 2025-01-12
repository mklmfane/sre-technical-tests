resource "aws_vpc" "technical_test_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "technical-test-vpc"
  }
}

resource "aws_internet_gateway" "technical_test_internet_gateway" {
  vpc_id = aws_vpc.technical_test_vpc.id
  tags = {
    Name = "technical-test-internet-gateway"
  }
}

resource "aws_eip" "technical_test_eip" {
  tags = {
    Name = "technical-test-eip"
  }
}

resource "aws_nat_gateway" "technical_test_nat_gateway" {
  allocation_id = aws_eip.technical_test_eip.id
  subnet_id     = aws_subnet.technical_test_public.id
  tags = {
    Name = "technical-test-nat-gateway"
  }
}

resource "aws_subnet" "technical_test_public" {
  vpc_id                  = aws_vpc.technical_test_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "technical-test-public"
  }
}

resource "aws_subnet" "technical_test_private" {
  vpc_id     = aws_vpc.technical_test_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "technical-test-private"
  }
}

resource "aws_route_table" "technical_test_routing_table" {
  vpc_id = aws_vpc.technical_test_vpc.id
  tags = {
    Name = "technical-test-routing-table"
  }
}

resource "aws_route" "route_internet_gateway" {
  route_table_id         = aws_route_table.technical_test_routing_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.technical_test_internet_gateway.id
}

resource "aws_instance" "technical_test_ariane" {
  ami           = var.ami_id # Example AMI; update as needed
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.technical_test_public.id
  security_groups = [aws_security_group.technical_test_ariane_security_group.id]
  tags = {
    Name = "technical-test-ariane"
  }
}