variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "s3_results" {
  description = "S3 bucket for Athena query results"
  type        = string
}

variable "glue_database" {
  description = "Glue database name"
  type        = string
}
