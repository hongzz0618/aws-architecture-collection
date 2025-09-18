output "api_gateway_url" {
  description = "API Gateway endpoint URL"
  value       = module.api_gateway.api_url
}

output "sagemaker_endpoint_name" {
  description = "SageMaker endpoint name"
  value       = module.sagemaker.endpoint_name
}

output "s3_bucket_name" {
  description = "S3 bucket for model artifacts"
  value       = module.model_bucket.bucket_name
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.inference_lambda.function_name
}

output "cloudwatch_dashboard" {
  description = "CloudWatch dashboard URL"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${var.project_name}-${var.environment}-dashboard"
}