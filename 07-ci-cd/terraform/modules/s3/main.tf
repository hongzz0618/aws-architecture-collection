resource "aws_s3_bucket" "artifact" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "artifact_acl" {
  bucket = aws_s3_bucket.artifact.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "artifact_versioning" {
  bucket = aws_s3_bucket.artifact.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_encryption" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.artifact.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket" { value = aws_s3_bucket.artifact.id }
output "bucket_arn" { value = aws_s3_bucket.artifact.arn }
