resource "aws_codedeploy_app" "this" {
  name = "${var.project}-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "${var.project}-dg"
  service_role_arn      = var.codedeploy_role_arn

  autoscaling_groups = [var.asg_name]

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Project"
      type  = "KEY_AND_VALUE"
      value = var.project
    }
  }
}
