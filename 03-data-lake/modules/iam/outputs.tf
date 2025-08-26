output "glue_role_arn" {
  description = "The IAM Role ARN for Glue"
  value       = aws_iam_role.glue_role.arn
}
