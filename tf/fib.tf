resource "aws_ecr_repository" "fib" {
  name = "fib"
}

output "fib_repository_url" {
  value = "${aws_ecr_repository.fib.repository_url}"
}

resource "aws_ecs_cluster" "fib_cluster" {
  name = "fib_cluster"
}

#cloudwatch log group
resource "aws_cloudwatch_log_group" "fib" {
  name = "fib"

  tags {
    Application = "fib"
  }
}

data "template_file" "fib" {
  template = "${file("${path.module}/tasks/fib.json")}"

  vars {
    image     = "${aws_ecr_repository.fib.repository_url}:latest"
    log_group = "${aws_cloudwatch_log_group.fib.name}"
  }
}

resource "aws_ecs_task_definition" "fib" {
  family                   = "fib"
  container_definitions    = "${data.template_file.fib.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "0.25vcpu"
  memory                   = "512"
  execution_role_arn       = "${aws_iam_role.ecs_task_assume_fib.arn}"
}

#service definition of fib
resource "aws_ecs_service" "fib" {
  name                              = "fib"
  cluster                           = "${aws_ecs_cluster.fib_cluster.id}"
  launch_type                       = "FARGATE"
  task_definition                   = "${aws_ecs_task_definition.fib.arn}"
  health_check_grace_period_seconds = 3600
  desired_count                     = 2

  network_configuration = {
    subnets         = ["${aws_subnet.fib_app_private_1.id}", "${aws_subnet.fib_app_private_2.id}", "${aws_subnet.fib_app_private_3.id}"]
    security_groups = ["${aws_security_group.fib_ecs_securitygroup.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.fib_alb_target_group.arn}"
    container_name   = "fib"
    container_port   = 9090
  }

  depends_on = [
    "aws_alb_listener.fib_http"
  ]

  lifecycle {
    ignore_changes = ["task_definition", "desired_count"]
  }
}


