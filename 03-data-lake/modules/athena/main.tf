resource "aws_s3_bucket" "results" {
  bucket = "${var.project_name}-athena-results"
}

resource "aws_athena_workgroup" "this" {
  name = "${var.project_name}-wg"

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.results.bucket}/"
    }
  }
}