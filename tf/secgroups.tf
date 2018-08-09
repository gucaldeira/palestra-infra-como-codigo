#scurity groups
resource "aws_security_group" "fib_ecs_securitygroup" {
  vpc_id      = "${aws_vpc.fib_app.id}"
  name        = "fib_ecs"
  description = "security group for ecs"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = ["${aws_security_group.fib_alb_securitygroup.id}"]
  }

  tags {
    Name = "fib_ecs"
  }
}

resource "aws_security_group" "fib_alb_securitygroup" {
  vpc_id      = "${aws_vpc.fib_app.id}"
  name        = "fib_alb"
  description = "security group for fib instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "fib_alb"
  }
}