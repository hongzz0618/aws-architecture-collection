# AWS Architectures

This repository contains a collection of **10 common AWS architectures**, each representing a real-world use case.  
The goal is to provide a clear and practical reference for learning AWS services and understanding how they work together.

Each architecture will include:

- An **architecture diagram**.
- **Infrastructure as Code** using Terraform.
- Example code or static assets.
- A **step-by-step guide** for deployment.

## Architectures

1. [**Static Website Hosting**](./01-static-website-hosting) – S3, CloudFront, ACM, Route 53
2. [**Serverless API Backend**](./02-serverless-api-backend) – API Gateway, Lambda, DynamoDB
3. [**Data Lake**](./03-data-lake) – S3, Glue, Athena, QuickSight
4. **Event-Driven Processing** – S3/EventBridge, Lambda, SNS/SQS
5. **Real-Time Data Streaming** – Kinesis Data Streams, Lambda, DynamoDB
6. **Containerized Web App** – ECS Fargate, ALB, EFS
7. **CI/CD Pipeline** – CodePipeline, CodeBuild, CodeDeploy
8. **Backup & Disaster Recovery** – S3, Glacier, AWS Backup
9. **Machine Learning Model Deployment** – SageMaker, Lambda, API Gateway
10. **Hybrid Cloud with VPN** – VPC, VPN Gateway, On-Premises Integration
