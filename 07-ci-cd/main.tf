terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# S3 for artifacts
module "s3" {
  source        = "./modules/s3"
  bucket_prefix = var.project_name
}

# IAM roles
module "iam" {
  source          = "./modules/iam"
  project_name    = var.project_name
  artifact_bucket = module.s3.bucket_name
}

# CodeBuild
module "codebuild" {
  source          = "./modules/codebuild"
  project_name    = var.project_name
  service_role_arn = module.iam.codebuild_role_arn
}

# CodePipeline
module "codepipeline" {
  source             = "./modules/codepipeline"
  project_name       = var.project_name
  artifact_bucket    = module.s3.bucket_name
  service_role_arn   = module.iam.codepipeline_role_arn
  codebuild_project  = module.codebuild.project_name
  github_owner       = var.github_owner
  github_repo        = var.github_repo
  github_branch      = var.github_branch
  github_oauth_token = var.github_oauth_token
}
