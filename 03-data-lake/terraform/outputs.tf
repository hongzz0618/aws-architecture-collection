output "raw_bucket" {
  value = aws_s3_bucket.raw.bucket
}

output "processed_bucket" {
  value = aws_s3_bucket.processed.bucket
}

output "curated_bucket" {
  value = aws_s3_bucket.curated.bucket
}

output "athena_results_bucket" {
  value = aws_s3_bucket.athena.bucket
}

output "glue_database" {
  value = aws_glue_catalog_database.db.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.raw_crawler.name
}

output "athena_workgroup" {
  value = aws_athena_workgroup.wg.name
}
