variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Glue access"
  type        = string
}
