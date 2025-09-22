# Train the model using local-exec
resource "null_resource" "train_model" {
  triggers = {
    # Re-train if any of these files change
    model_script  = filemd5("${path.module}/scripts/create_model.py")
    requirements  = filemd5("${path.module}/scripts/requirements.txt")
    timestamp     = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOF
      cd '${path.module}/scripts';
      pip install -r requirements.txt;
      python create_model.py --bucket ${var.s3_bucket_name} --region ${var.aws_region}
    EOF
  }

  # Wait for S3 bucket to be ready
  depends_on = [var.s3_bucket_id]
}

# Upload the generated model to S3
resource "aws_s3_object" "model_artifact" {
  bucket = var.s3_bucket_name
  key    = "model.tar.gz"
  source = "${path.module}/scripts/model.tar.gz"

  # Only upload if the file exists
  count = fileexists("${path.module}/scripts/model.tar.gz") ? 1 : 0
  
  depends_on = [null_resource.train_model]
}
