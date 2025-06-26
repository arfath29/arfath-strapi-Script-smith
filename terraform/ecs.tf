resource "aws_ecs_cluster" "strapi_cluster" {
  name = "arfath-strapi-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ecs-tasks.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
data "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskExecutionRole"
}


resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_role.arn


  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.docker_image # Ensure this points to a valid image:tag
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      essential = true
      # logConfiguration = {
      #   logDriver = "awslogs"
      #   options = {
      #     awslogs-group         = aws_cloudwatch_log_group.strapi_logs.name
      #     awslogs-region        = var.aws_region
      #     awslogs-stream-prefix = "ecs/strapi"
      #   }
      # }
    }
  ])

}

resource "aws_ecs_service" "strapi_service" {
  name            = "arfath-strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  launch_type     = "FARGATE"
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  # capacity_provider_strategy {
  #   capacity_provider = "FARGATE_SPOT"
  #   weight            = 1
  # }
  desired_count           = 1
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  network_configuration {
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.blue_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }
  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      load_balancer,
      network_configuration
    ]
  }
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  # depends_on = [
  #   aws_lb_listener.http,
  #   aws_codedeploy_deployment_group.strapi_group
  # ]
  enable_execute_command = true

  # Add this CloudWatch tags block if using service-level metrics
  tags = {
    environment = "prod"
    project     = "strapi"
  }

}

#   depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
# }
