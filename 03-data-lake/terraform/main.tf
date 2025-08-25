locals {
  raw_bucket       = "${var.project_name}-raw"
  processed_bucket = "${var.project_name}-processed"
  curated_bucket   = "${var.project_name}-curated"
  athena_bucket    = "${var.project_name}-athena-results"
  glue_db_name     = replace("${var.project_name}_db", "-", "_")
  workgroup_name   = "${var.project_name}_wg"
}

# -----------------------------
# S3 Buckets
# -----------------------------
resource "aws_s3_bucket" "raw" {
  bucket = local.raw_bucket
  tags   = { Environment = "dev", Zone = "raw", Project = var.project_name }
}

resource "aws_s3_bucket" "processed" {
  bucket = local.processed_bucket
  tags   = { Environment = "dev", Zone = "processed", Project = var.project_name }
}

resource "aws_s3_bucket" "curated" {
  bucket = local.curated_bucket
  tags   = { Environment = "dev", Zone = "curated", Project = var.project_name }
}

resource "aws_s3_bucket" "athena" {
  bucket = local.athena_bucket
  tags   = { Environment = "dev", Zone = "athena-results", Project = var.project_name }
}

# Block public access (basic)
resource "aws_s3_bucket_public_access_block" "raw" {
  bucket                  = aws_s3_bucket.raw.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_public_access_block" "processed" {
  bucket                  = aws_s3_bucket.processed.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_public_access_block" "curated" {
  bucket                  = aws_s3_bucket.curated.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_public_access_block" "athena" {
  bucket                  = aws_s3_bucket.athena.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning recommended for data lake buckets
resource "aws_s3_bucket_versioning" "raw" {
  bucket = aws_s3_bucket.raw.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_versioning" "processed" {
  bucket = aws_s3_bucket.processed.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_versioning" "curated" {
  bucket = aws_s3_bucket.curated.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_versioning" "athena" {
  bucket = aws_s3_bucket.athena.id
  versioning_configuration { status = "Enabled" }
}

# -----------------------------
# Glue: Database + Crawler Role + Crawler
# -----------------------------
resource "aws_glue_catalog_database" "db" {
  name = local.glue_db_name
}

# IAM Role for Glue Crawler
data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_crawler_role" {
  name               = "${var.project_name}-glue-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

# Attach AWS managed policies + minimal S3 access to our buckets
resource "aws_iam_role_policy_attachment" "glue_service_policy" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "${var.project_name}-glue-s3"
  role = aws_iam_role.glue_crawler_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action: [
          "s3:ListBucket"
        ],
        Resource: [
          aws_s3_bucket.raw.arn,
          aws_s3_bucket.processed.arn,
          aws_s3_bucket.curated.arn
        ]
      },
      {
        Effect: "Allow",
        Action: [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource: [
          "${aws_s3_bucket.raw.arn}/*",
          "${aws_s3_bucket.processed.arn}/*",
          "${aws_s3_bucket.curated.arn}/*"
        ]
      }
    ]
  })
}

# Glue Crawler scanning RAW prefix "data/"
resource "aws_glue_crawler" "raw_crawler" {
  name          = "${var.project_name}-raw-crawler"
  database_name = aws_glue_catalog_database.db.name
  role          = aws_iam_role.glue_crawler_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.raw.bucket}/data/"
  }

  # On-demand; the script will start it.
  configuration = jsonencode({
    Version = 1.0
  })

  tags = { Project = var.project_name }
}

# -----------------------------
# Athena: Workgroup + (optional) named query
# -----------------------------
resource "aws_athena_workgroup" "wg" {
  name = local.workgroup_name

  configuration {
    enforce_workgroup_configuration = true
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena.bucket}/${var.athena_result_prefix}"
    }
  }

  tags = { Project = var.project_name }
}

# Example named query after crawler creates tables (you can run it later)
resource "aws_athena_named_query" "sample_query" {
  name      = "sample_count_customers"
  database  = aws_glue_catalog_database.db.name
  workgroup = aws_athena_workgroup.wg.name
  query     = "SELECT COUNT(*) AS cnt FROM ${aws_glue_catalog_database.db.name}.customers;"
}

# -----------------------------
# (Optional) QuickSight
# -----------------------------
# QuickSight automation often needs account-level setup (subscription, user ARNs).
# Keep this manual in README to avoid apply failures.
# You can later add:
# - aws_quicksight_data_source (Athena)
# - aws_quicksight_dataset
# - aws_quicksight_analysis / dashboard