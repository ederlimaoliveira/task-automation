resource "aws_vpc" "vpc-task" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Vpc for task"
  }
}