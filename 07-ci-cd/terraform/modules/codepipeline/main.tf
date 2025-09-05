variable "pipeline_name" { type = string }
variable "github_owner" { type = string }
variable "github_repo" { type = string }
variable "github_branch" { type = string }
variable "oauth_token_secret" { type = string } # ARN of secret with token
variable "artifact_bucket" { type = string }
variable "codebuild_project" { type = string }
variable "codedeploy_app_name" { type = string }
variable "codedeploy_group" { type = string }
variable "service_role_arn" { type = string }

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = var.oauth_token_secret
}

resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = var.service_role_arn

  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner  = var.github_owner
        Repo   = var.github_repo
        Branch = var.github_branch
        OAuthToken = data.aws_secretsmanager_secret_version.github_token.secret_string
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = var.codebuild_project
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      configuration = {
        ApplicationName     = var.codedeploy_app_name
        DeploymentGroupName = var.codedeploy_group
      }
    }
  }
}
