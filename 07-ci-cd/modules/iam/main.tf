# CodeBuild IAM Role
resource "aws_iam_role" "codebuild" {
  name = "${var.project_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codebuild.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Inline policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project_name}-codebuild-inline"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow S3 access for artifacts
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::${var.artifact_bucket}/*"
      },
      # Allow CloudWatch Logs for build logs
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.project_name}:*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}


# CodePipeline IAM Role
resource "aws_iam_role" "codepipeline" {
  name = "${var.project_name}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codepipeline.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Inline policy for CodePipeline
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project_name}-codepipeline-inline"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::${var.artifact_bucket}/*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ],
        Resource = "*"
      }
    ]
  })
}
# CodeDeploy IAM Role
resource "aws_iam_role" "codedeploy" {
  name = "${var.project_name}-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Inline Policy for CodeDeploy
resource "aws_iam_role_policy" "codedeploy_policy" {
  name = "${var.project_name}-codedeploy-inline"
  role = aws_iam_role.codedeploy.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # EC2 + AutoScaling — required for deployments
      {
        Effect = "Allow",
        Action = [
          "ec2:Describe*",
          "autoscaling:CompleteLifecycleAction",
          "autoscaling:DeleteLifecycleHook",
          "autoscaling:Describe*",
          "autoscaling:PutLifecycleHook",
          "autoscaling:RecordLifecycleActionHeartbeat",
          "autoscaling:UpdateAutoScalingGroup"
        ],
        Resource = "*"
      },
      # CloudWatch Logs — so CodeDeploy can log deployment events
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      # S3 — to fetch application bundles / AppSpec file
      {
        Effect = "Allow",
        Action = [
          "s3:Get*",
          "s3:List*"
        ],
        Resource = "arn:aws:s3:::${var.artifact_bucket}/*"
      }
    ]
  })
}

# Output for root module
output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy.arn
}


# Outputs
output "codebuild_role_arn" {
  value = aws_iam_role.codebuild.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline.arn
}
