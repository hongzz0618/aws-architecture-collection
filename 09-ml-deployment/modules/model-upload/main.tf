# Create a dummy model file and upload to S3
resource "aws_s3_object" "model_artifact" {
  bucket = var.s3_bucket_name
  key    = "model.tar.gz"

  # Use a simple Python script to generate a model
  source = "${path.module}/scripts/generated_model.tar.gz"

  # Trigger re-upload if the model script changes
  etag = filemd5("${path.module}/scripts/create_model.py")
  
  depends_on = [null_resource.train_model]
}

# Train the model using local-exec
resource "null_resource" "train_model" {
  triggers = {
    # Re-train if any of these files change
    model_script  = filemd5("${path.module}/scripts/create_model.py")
    requirements  = filemd5("${path.module}/scripts/requirements.txt")
    timestamp     = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
      cd ${path.module}/scripts && \
      python -m pip install -r requirements.txt && \
      python create_model.py --bucket ${var.s3_bucket_name} --region ${var.aws_region}
    EOF
  }

  # Wait for S3 bucket to be ready
  depends_on = [var.s3_bucket_id]
}