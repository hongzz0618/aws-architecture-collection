output "workgroup_name" {
  description = "The Athena workgroup name"
  value       = aws_athena_workgroup.this.name
}

output "results_bucket" {
  description = "S3 bucket used for Athena query results"
  value       = var.s3_results
}
