resource "aws_codebuild_project" "this" {
  name          = var.project_name
  description   = "Build project for ${var.project_name}"
  service_role  = var.service_role_arn
  build_timeout = 5

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  source {
    type = "CODEPIPELINE"
  }
}

output "project_name" {
  value = aws_codebuild_project.this.name
}
