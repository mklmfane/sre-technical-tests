
resource "aws_instance" "technical_test_falcon" {
  ami           = var.ami_id # Example AMI; update as needed
  instance_type = var.instance_type
  subnet_id     = aws_subnet.technical_test_private.id
  security_groups = [aws_security_group.technical_test_falcon_security_group.id]
  tags = {
    Name = "technical-test-falcon"
  }
}

resource "aws_instance" "technical_test_redis" {
  ami           = var.ami_id # Example AMI; update as needed
  instance_type = var.instance_type
  subnet_id     = aws_subnet.technical_test_private.id
  security_groups = [aws_security_group.technical_test_redis_security_group.id]
  tags = {
    Name = "technical-test-redis"
  }
}

resource "aws_security_group" "technical_test_ariane_security_group" {
  vpc_id = aws_vpc.technical_test_vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["82.11.22.33/32", "81.44.55.87/32", "87.12.33.88/32"]
    description = "HTTPS inbound from Office, VPN, Home"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Internet outbound"
  }
  tags = {
    Name = "technical-test-ariane-security-group"
  }
}

resource "aws_security_group" "technical_test_falcon_security_group" {
  vpc_id = aws_vpc.technical_test_vpc.id
  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    security_groups = [aws_security_group.technical_test_ariane_security_group.id]
    description     = "technical-test-ariane-security-group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Internet outbound"
  }
  tags = {
    Name = "technical-test-falcon-security-group"
  }
}

resource "aws_security_group" "technical_test_redis_security_group" {
  vpc_id = aws_vpc.technical_test_vpc.id
  ingress {
    from_port   = 6399
    to_port     = 6399
    protocol    = "tcp"
    security_groups = [aws_security_group.technical_test_falcon_security_group.id]
    description     = "technical-test-falcon-security-group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Internet outbound"
  }
  tags = {
    Name = "technical-test-redis-security-group"
  }
}
