variable "project_name" { type = string }
variable "service_role_arn" { type = string }
variable "artifact_bucket" { type = string }

resource "aws_codebuild_project" "this" {
  name          = var.project_name
  service_role  = var.service_role_arn
  artifacts {
    type = "S3"
    location = var.artifact_bucket
    packaging = "ZIP"
    path = "artifacts"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }
  source {
    type = "CODEPIPELINE"
  }
}
output "project_name" { value = aws_codebuild_project.this.name }
