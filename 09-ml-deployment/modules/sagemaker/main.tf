# SageMaker Model using XGBoost built-in algorithm
resource "aws_sagemaker_model" "ml_model" {
  name               = "${var.project_name}-${var.environment}-${var.model_name}"
  execution_role_arn = var.iam_role_arn

  primary_container {
    image = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-xgboost:1.5-1"
    model_data_url = var.model_upload_complete != null ? "s3://${var.model_bucket_name}/model.tar.gz" : null
    environment = {
      SAGEMAKER_PROGRAM = "inference.py"
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# SageMaker Endpoint Configuration
resource "aws_sagemaker_endpoint_configuration" "endpoint_config" {
  name = "${var.project_name}-${var.environment}-endpoint-config"

  production_variants {
    variant_name           = "primary"
    model_name             = aws_sagemaker_model.ml_model.name
    initial_instance_count = 1
    instance_type          = var.instance_type
    initial_variant_weight = 1.0
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# SageMaker Endpoint
resource "aws_sagemaker_endpoint" "endpoint" {
  name                 = "${var.project_name}-${var.environment}-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.endpoint_config.name

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}