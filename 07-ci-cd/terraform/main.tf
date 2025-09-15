terraform {
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

module "artifact_bucket" {
  source      = "./modules/s3"
  bucket_name = var.artifact_bucket_name
}

module "iam" {
  source              = "./modules/iam"
  artifact_bucket_arn = module.artifact_bucket.bucket_arn
}

module "ec2asg" {
  source               = "./modules/ec2asg"
  instance_type        = var.instance_type
  desired_capacity     = var.asg_desired_capacity
  iam_instance_profile = module.iam.instance_profile_name
}

module "codebuild" {
  source           = "./modules/codebuild"
  project_name     = var.codebuild_project_name
  service_role_arn = module.iam.codebuild_role_arn
  artifact_bucket  = module.artifact_bucket.bucket
}

module "codedeploy" {
  source           = "./modules/codedeploy"
  application_name = var.codedeploy_application_name
  deployment_group = var.codedeploy_deployment_group
  service_role_arn = module.iam.codedeploy_role_arn
  asg_name         = module.ec2asg.asg_name
}

module "codepipeline" {
  source              = "./modules/codepipeline"
  pipeline_name       = var.pipeline_name
  github_owner        = var.github_owner
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  oauth_token_secret  = var.github_oauth_token_secret_arn
  artifact_bucket     = module.artifact_bucket.bucket
  codebuild_project   = module.codebuild.project_name
  codedeploy_app_name = module.codedeploy.application_name
  codedeploy_group    = module.codedeploy.deployment_group_name
  service_role_arn    = module.iam.codepipeline_role_arn
}
