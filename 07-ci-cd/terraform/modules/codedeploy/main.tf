variable "application_name" { type = string }
variable "deployment_group" { type = string }
variable "service_role_arn" { type = string }

resource "aws_codedeploy_app" "app" {
  name = var.application_name
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "dg" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = var.deployment_group
  service_role_arn      = var.service_role_arn

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  # Example: EC2 tag-based targets (adjust to your ASG / EC2 tags)
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "example-app-server"
    }
  }
}

output "application_name" { value = aws_codedeploy_app.app.name }
output "deployment_group_name" { value = aws_codedeploy_deployment_group.dg.deployment_group_name }
