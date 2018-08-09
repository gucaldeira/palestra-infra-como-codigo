resource "aws_iam_role" "ecs_task_assume_fib" {
  name = "ecs_task_assume_fib"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_task_assume_fib" {
  name = "ecs_task_assume_fib"
  role = "${aws_iam_role.ecs_task_assume_fib.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                 "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ecs_autoscale_role_fib" {
  name               = "ecs_autoscale_role_fib"
  assume_role_policy = "${file("${path.module}/policies/ecs-autoscale-role.json")}"
}
resource "aws_iam_role_policy" "ecs_autoscale_role_fib_policy" {
  name   = "ecs_autoscale_role_fib_policy"
  policy = "${file("${path.module}/policies/ecs-autoscale-role-policy.json")}"
  role   = "${aws_iam_role.ecs_autoscale_role_fib.id}"
}
