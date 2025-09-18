# S3 Bucket for model artifacts
module "model_bucket" {
  source = "./modules/s3"

  bucket_name    = "${var.project_name}-${var.environment}-models"
  environment    = var.environment
  project_name   = var.project_name
  enable_versioning = true
}

# IAM Roles and Policies
module "iam" {
  source = "./modules/iam"

  environment    = var.environment
  project_name   = var.project_name
  s3_bucket_arn  = module.model_bucket.bucket_arn
}

# SageMaker Resources
module "sagemaker" {
  source = "./modules/sagemaker"

  environment        = var.environment
  project_name       = var.project_name
  model_name         = var.model_name
  iam_role_arn       = module.iam.sagemaker_role_arn
  model_bucket_name  = module.model_bucket.bucket_name
  instance_type      = var.sagemaker_instance_type
}

# Lambda Function
module "inference_lambda" {
  source = "./modules/lambda"

  environment          = var.environment
  project_name         = var.project_name
  runtime              = var.lambda_runtime
  handler              = "index.handler"
  source_dir           = "./src/lambda/inference"
  sagemaker_role_arn   = module.iam.sagemaker_role_arn
  sagemaker_endpoint   = module.sagemaker.endpoint_name
}

# API Gateway
module "api_gateway" {
  source = "./modules/api-gateway"

  environment          = var.environment
  project_name         = var.project_name
  lambda_function_name = module.inference_lambda.function_name
  lambda_invoke_arn    = module.inference_lambda.invoke_arn
}