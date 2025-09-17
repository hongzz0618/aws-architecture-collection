resource "aws_codedeploy_app" "this" {
  name = "${var.project_name}-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "${var.project_name}-dg"
  service_role_arn      = var.service_role_arn

  autoscaling_groups = [var.asg_name]

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Project"
      type  = "KEY_AND_VALUE"
      value = var.project_name
    }
  }
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.this.name
}

output "codedeploy_group_name" {
  value = aws_codedeploy_deployment_group.this.deployment_group_name
}