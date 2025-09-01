output "kinesis_stream_name" {
  value = module.kinesis.stream_name
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "lambda_name" {
  value = module.lambda.function_name
}
