# Simple model upload
resource "aws_s3_object" "dummy_model" {
  bucket = var.s3_bucket_name
  key    = "model.tar.gz"
  
  # Create a valid tar.gz file content that SageMaker will accept
  content_base64 = "H4sIAAAAAAAAA+3PQQqDMBQF0L1P8Q+4cKFu3IkbFyKlTW1Dm4Q0Fdy9m2rFhYv3wTk8OAwDp2nipmmiYRjSvu9T13Wpbdv0bNs2NU2T6rpOVVWlsixTUfykKIp0z/M8ZVmWsiyLWZbFLMtilmUxy7KYZVnMsixmWRazLItZlsUsy2KWZTHLsphlWcyyLGZZFrMsi1mWxSzLYpZlMcuy+BcAAP//AwDe1WIlACAAAA=="
}
