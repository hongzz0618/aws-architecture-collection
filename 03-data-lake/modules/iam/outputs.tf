output "glue_role_arn" {
  description = "The IAM role ARN for AWS Glue"
  value       = aws_iam_role.glue_role.arn
}
