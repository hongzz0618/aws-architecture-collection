output "model_upload_complete" {
  description = "Signal that model upload is complete"
  value       = try(aws_s3_object.model_artifact[0].etag, "dummy_complete")
}

output "model_s3_url" {
  description = "S3 URL of the uploaded model"
  value       = "s3://${var.s3_bucket_name}/model.tar.gz"
}