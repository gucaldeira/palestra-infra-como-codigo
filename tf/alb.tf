#alb
resource "random_id" "fib_tg_randon_sufix" {
  byte_length = 3
}

#alb definition
resource "aws_alb" "fib" {
  name            = "alb-fib-app"
  subnets         = ["${aws_subnet.fib_app_public_1.id}", "${aws_subnet.fib_app_public_2.id}", "${aws_subnet.fib_app_public_3.id}"]
  security_groups = ["${aws_security_group.fib_alb_securitygroup.id}"]

  tags {
    Name = "alb-fib-app"
  }
}

resource "aws_alb_target_group" "fib_alb_target_group" {
  name        = "fib-app-alb-tg-${random_id.fib_tg_randon_sufix.hex}"
  port        = 9090
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.fib_app.id}"
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    path                = "/?n=1"
    interval            = 60
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_alb_listener" "fib_http" {
  load_balancer_arn = "${aws_alb.fib.arn}"
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.fib_alb_target_group"]

  default_action {
    target_group_arn = "${aws_alb_target_group.fib_alb_target_group.arn}"
    type             = "forward"
  }
}

output "fib_alb_dns_name" {
  value = "${aws_alb.fib.dns_name}"
}