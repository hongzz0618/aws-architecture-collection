variable "region" { type = string, default = "us-east-1" }

variable "artifact_bucket_name" {
  type        = string
  description = "Unique S3 bucket name for artifacts"
  default     = "ci-cd-artifacts-123456-please-change"
}

variable "pipeline_name" { type = string, default = "example-ci-cd-pipeline" }
variable "codebuild_project_name" { type = string, default = "example-codebuild" }

variable "codedeploy_application_name" { type = string, default = "example-codedeploy-app" }
variable "codedeploy_deployment_group" { type = string, default = "example-deployment-group" }

# GitHub integration
variable "github_owner" { type = string }
variable "github_repo"  { type = string }
variable "github_branch" { type = string, default = "main" }
# Store a GitHub personal access token in Secrets Manager and provide ARN here
variable "github_oauth_token_secret_arn" { type = string }
