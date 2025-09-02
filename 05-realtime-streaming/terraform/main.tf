terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.region
}

module "kinesis" {
  source      = "./modules/kinesis"
  stream_name = "my-stream"
  shard_count = 1
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "my-realtime-table"
  hash_key   = "userId"
}

module "lambda" {
  source         = "./modules/lambda"
  function_name  = "kinesisProcessor"
  handler        = "index.handler"
  runtime        = "nodejs18.x"
  source_path    = "../lambdas/kinesisProcessor"
  kinesis_arn    = module.kinesis.stream_arn
  dynamodb_table = module.dynamodb.table_name
}