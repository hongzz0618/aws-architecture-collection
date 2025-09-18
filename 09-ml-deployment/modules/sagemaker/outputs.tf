output "endpoint_name" {
  description = "SageMaker endpoint name"
  value       = aws_sagemaker_endpoint.endpoint.name
}

output "model_name" {
  description = "SageMaker model name"
  value       = aws_sagemaker_model.ml_model.name
}