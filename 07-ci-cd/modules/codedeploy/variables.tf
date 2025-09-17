variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "service_role_arn" {
  description = "IAM role ARN for CodeDeploy"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name to target deployments"
  type        = string
}
