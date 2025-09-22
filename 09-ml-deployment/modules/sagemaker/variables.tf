variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "model_name" {
  description = "Model name"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN for SageMaker"
  type        = string
}

variable "model_bucket_name" {
  description = "S3 bucket name for model artifacts"
  type        = string
}

variable "instance_type" {
  description = "SageMaker instance type"
  type        = string
}

variable "model_upload_complete" {
  description = "Signal that model upload is complete"
  type        = any
  default     = null
}