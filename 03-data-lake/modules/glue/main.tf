resource "aws_glue_catalog_database" "this" {
  name = var.database
}

resource "aws_glue_crawler" "this" {
  name         = "${var.database}-crawler"
  role         = var.role_arn
  database_name = aws_glue_catalog_database.this.name

  s3_target {
    path = "s3://${var.s3_bucket}/raw/"
  }

  schedule = "cron(0 * * * ? *)" # every hour
}

output "database_name" {
  value = aws_glue_catalog_database.this.name
}
