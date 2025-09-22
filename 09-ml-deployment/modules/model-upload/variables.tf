variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for model artifacts"
  type        = string
}

variable "s3_bucket_id" {
  description = "S3 bucket ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}