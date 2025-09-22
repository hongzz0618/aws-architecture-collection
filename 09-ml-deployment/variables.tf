variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "ml-deployment"
}

variable "sagemaker_instance_type" {
  description = "SageMaker instance type"
  type        = string
  default     = "ml.t2.medium"
  validation {
    condition     = can(regex("^ml\\.", var.sagemaker_instance_type))
    error_message = "Instance type must be a valid SageMaker instance type."
  }
}

variable "model_name" {
  description = "Name of the ML model"
  type        = string
  default     = "iris-classifier"
}

variable "lambda_runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "nodejs18.x"
}