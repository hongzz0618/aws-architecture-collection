output "artifact_bucket" { value = module.artifact_bucket.bucket }
output "codebuild_project" { value = module.codebuild.project_name }
output "codedeploy_app" { value = module.codedeploy.application_name }
output "codedeploy_deployment_group" { value = module.codedeploy.deployment_group_name }
output "codepipeline_name" { value = module.codepipeline.pipeline_name }
output "ec2_asg_name" { value = module.ec2asg.asg_name }
