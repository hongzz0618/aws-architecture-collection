output "artifact_bucket" {
  value = module.s3.bucket_name
}

output "codebuild_project" {
  value = module.codebuild.project_name
}

output "codepipeline_name" {
  value = module.codepipeline.pipeline_name
}
