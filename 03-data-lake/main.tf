module "s3" {
  source       = "./modules/s3"
  bucket_name  = "${var.project_name}-data-lake"
}

module "iam" {
  source         = "./modules/iam"
  project_name   = var.project_name
  s3_bucket_arn  = module.s3.bucket_arn
}

module "glue" {
  source       = "./modules/glue"
  database     = "${var.project_name}_db"
  s3_bucket    = module.s3.bucket_name
  role_arn     = module.iam.glue_role_arn
}

module "athena" {
  source         = "./modules/athena"
  project_name   = var.project_name
  s3_results     = module.s3.bucket_name
  glue_database  = module.glue.database_name
}
