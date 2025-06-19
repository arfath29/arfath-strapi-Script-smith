# provider "aws" {
#   region = "ap-south-1"
# }
# resource "aws_instance" "task-5" {
#   ami           = "ami-0f918f7e67a3323f0"
#   instance_type = "t2.medium"
#   user_data     = file("user_data.sh")
#   key_name      = "internship"
#   tags = {
#     Name = "Task5Instance"
#   }
#   security_groups = [aws_security_group.task-5-sg.name]
# }

# resource "aws_security_group" "task-5-sg" {
#   name        = "task-4-sg"
#   description = "Security group for Task 4 instance"
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 1337
#     to_port     = 1337
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "task-5-sg"
#   }
# }

