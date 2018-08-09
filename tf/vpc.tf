# Internet VPC
resource "aws_vpc" "fib_app" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "fib_app"
  }
}

# Subnets
resource "aws_subnet" "fib_app_public_1" {
  vpc_id                  = "${aws_vpc.fib_app.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags {
    Name = "fib_app_public_1"
  }
}

resource "aws_subnet" "fib_app_public_2" {
  vpc_id                  = "${aws_vpc.fib_app.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags {
    Name = "fib_app_public_2"
  }
}

resource "aws_subnet" "fib_app_public_3" {
  vpc_id                  = "${aws_vpc.fib_app.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"

  tags {
    Name = "fib_app_public_3"
  }
}

resource "aws_subnet" "fib_app_private_1" {
  vpc_id                  = "${aws_vpc.fib_app.id}"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"

  tags {
    Name = "fib_app_private_1"
  }
}

resource "aws_subnet" "fib_app_private_2" {
  vpc_id                  = "${aws_vpc.fib_app.id}"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags {
    Name = "fib_app_private_2"
  }
}

resource "aws_subnet" "fib_app_private_3" {
  vpc_id                  = "${aws_vpc.fib_app.id}"
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"

  tags {
    Name = "fib_app_private_3"
  }
}

# Internet GW
resource "aws_internet_gateway" "fib_app_gw" {
  vpc_id = "${aws_vpc.fib_app.id}"

  tags {
    Name = "fib_app"
  }
}

# route tables
resource "aws_route_table" "fib_app_public" {
  vpc_id = "${aws_vpc.fib_app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.fib_app_gw.id}"
  }

  tags {
    Name = "fib_app_public_1"
  }
}

# route associations public
resource "aws_route_table_association" "fib_app_public_1_a" {
  subnet_id      = "${aws_subnet.fib_app_public_1.id}"
  route_table_id = "${aws_route_table.fib_app_public.id}"
}

resource "aws_route_table_association" "fib_app_public_2_a" {
  subnet_id      = "${aws_subnet.fib_app_public_2.id}"
  route_table_id = "${aws_route_table.fib_app_public.id}"
}

resource "aws_route_table_association" "fib_app_public_3_a" {
  subnet_id      = "${aws_subnet.fib_app_public_3.id}"
  route_table_id = "${aws_route_table.fib_app_public.id}"
}
