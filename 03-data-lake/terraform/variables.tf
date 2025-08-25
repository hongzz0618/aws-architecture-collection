variable "project_name" {
  description = "Project name prefix (used in resource names)"
  type        = string
}

variable "region" {
  description = "AWS region for all resources"
  type        = string
}

variable "athena_result_prefix" {
  description = "S3 prefix for Athena query results"
  type        = string
}
