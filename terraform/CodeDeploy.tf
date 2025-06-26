resource "aws_codedeploy_app" "strapi" {
  name             = "arfath-strapi-codedeploy"
  compute_platform = "ECS"
}
data "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployServiceRole"
}
resource "aws_codedeploy_deployment_group" "strapi_group" {
  app_name               = aws_codedeploy_app.strapi.name
  deployment_group_name  = "strapi-deploy-group"
  service_role_arn       = data.aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }


  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.strapi_cluster.name
    service_name = aws_ecs_service.strapi_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = aws_lb_target_group.blue_tg.name
      }

      target_group {
        name = aws_lb_target_group.green_tg.name
      }

      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }
    }
  }
  depends_on = [aws_ecs_service.strapi_service]
}
