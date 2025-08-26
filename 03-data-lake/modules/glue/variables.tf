variable "database" {
  description = "Glue database name"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "role_arn" {
  description = "IAM role for Glue crawler"
  type        = string
}
