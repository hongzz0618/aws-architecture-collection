output "database_name" {
  description = "The name of the Glue database"
  value       = aws_glue_catalog_database.this.name
}

output "crawler_name" {
  description = "The name of the Glue crawler"
  value       = aws_glue_crawler.this.name
}
