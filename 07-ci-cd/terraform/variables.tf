variable "region" { type = string, default = "us-east-1" }

variable "artifact_bucket_name" {
  description = "Globally unique artifact bucket name"
  type        = string
  default     = "ci-cd-artifacts-REPLACE-WITH-UNIQUE"
}

variable "pipeline_name" { type = string, default = "example-ci-cd-pipeline" }
variable "codebuild_project_name" { type = string, default = "example-codebuild" }

variable "codedeploy_application_name" { type = string, default = "example-codedeploy-app" }
variable "codedeploy_deployment_group" { type = string, default = "example-deployment-group" }

# GitHub integration
variable "github_owner" { type = string }
variable "github_repo"  { type = string }
variable "github_branch" { type = string, default = "main" }
# ARN of secret in Secrets Manager that stores a GitHub personal access token
variable "github_oauth_token_secret_arn" { type = string }

# EC2 ASG sizing (small default)
variable "asg_desired_capacity" { type = number, default = 1 }
variable "instance_type" { type = string, default = "t3.micro" }
