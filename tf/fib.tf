resource "aws_ecr_repository" "fib" {
  name = "fib"
}

output "fib_repository_url" {
  value = "${aws_ecr_repository.fib.repository_url}"
}
