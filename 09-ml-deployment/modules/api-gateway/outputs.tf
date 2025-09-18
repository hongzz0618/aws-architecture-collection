output "api_url" {
  description = "API Gateway URL"
  value       = aws_apigatewayv2_api.ml_api.api_endpoint
}

output "api_id" {
  description = "API Gateway ID"
  value       = aws_apigatewayv2_api.ml_api.id
}