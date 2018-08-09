#autoscaling
resource "aws_appautoscaling_target" "fib_autoscaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.fib_cluster.name}/${aws_ecs_service.fib.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${aws_iam_role.ecs_autoscale_role_fib.arn}"
  min_capacity       = 2
  max_capacity       = 10
}

resource "aws_appautoscaling_policy" "fib_up" {
  name               = "fib_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.fib_cluster.name}/${aws_ecs_service.fib.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.fib_autoscaling_target"]
}

resource "aws_appautoscaling_policy" "fib_down" {
  name               = "fib_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.fib_cluster.name}/${aws_ecs_service.fib.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.fib_autoscaling_target"]
}

/* metric used for auto scale */
resource "aws_cloudwatch_metric_alarm" "fib_service_cpu_high" {
  alarm_name          = "fib_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "65"

  dimensions {
    ClusterName = "${aws_ecs_cluster.fib_cluster.name}"
    ServiceName = "${aws_ecs_service.fib.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.fib_up.arn}"]
  ok_actions    = ["${aws_appautoscaling_policy.fib_down.arn}"]
}
