output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.inference_function.function_name
}

output "invoke_arn" {
  description = "Lambda invoke ARN"
  value       = aws_lambda_function.inference_function.invoke_arn
}

output "function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.inference_function.arn
}