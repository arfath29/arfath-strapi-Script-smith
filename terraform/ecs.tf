resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.docker_image
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      essential = true
    }
  ])
}

# resource "aws_ecs_service" "strapi_service" {
#   name            = "strapi-service"
#   cluster         = aws_ecs_cluster.strapi_cluster.id
#   launch_type     = "FARGATE"
#   task_definition = aws_ecs_task_definition.strapi_task.arn
#   desired_count   = 1

#   network_configuration {
#     subnets          = [aws_subnet.subnet.id]
#     security_groups  = [aws_security_group.ecs_sg.id]
#     assign_public_ip = true
#   }

#   depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
# }
