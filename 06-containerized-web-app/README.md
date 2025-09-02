# 06 - Containerized Web App with ECS Fargate, ALB, and EFS

## 📌 Overview

This pattern demonstrates how to deploy a containerized web application on **Amazon ECS Fargate** with:

- **Application Load Balancer (ALB)** for traffic distribution.
- **Amazon EFS** for persistent shared storage across tasks.
- **VPC** with public and private subnets for secure networking.

It represents a common architecture used for **modernizing monolithic applications** or **hosting stateful containerized workloads**.

---

## 🏗️ Architecture Diagram

![Architecture Diagram](./diagram.png)

---

## 🚀 Use Case

- Hosting a **containerized web application** that requires:
  - Automatic scaling.
  - Secure access via HTTPS.
  - Shared file storage (e.g., uploaded files, logs).
- Example: Content management systems (WordPress, Drupal), legacy apps migrated to AWS.

---

## 🔧 AWS Services Used

- **VPC** – Public and private subnets with NAT Gateway.
- **ECS Fargate** – Serverless containers.
- **Application Load Balancer (ALB)** – Distributes traffic.
- **Amazon EFS** – Shared file system for stateful workloads.
- **CloudWatch Logs** – Application and infrastructure logging.
- **IAM Roles** – Task execution and service roles.
