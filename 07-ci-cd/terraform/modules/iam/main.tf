variable "artifact_bucket_arn" { type = string }

# Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "codebuild.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["s3:GetObject","s3:PutObject","s3:GetObjectVersion","s3:GetBucketLocation"], Resource = "${var.artifact_bucket_arn}/*" },
      { Effect = "Allow", Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"], Resource = "*" }
    ]
  })
}

# Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "codepipeline.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = aws_iam_role.codepipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["s3:*"], Resource = "${var.artifact_bucket_arn}/*" },
      { Effect = "Allow", Action = ["codebuild:StartBuild","codebuild:BatchGetBuilds"], Resource = "*" },
      { Effect = "Allow", Action = ["codedeploy:*"], Resource = "*" }
    ]
  })
}

# Role for CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "codedeploy.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "codedeploy_policy" {
  role = aws_iam_role.codedeploy_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Action = ["autoscaling:*","ec2:*","s3:*","cloudwatch:*"], Resource = "*" }]
  })
}

output "codebuild_role_arn" { value = aws_iam_role.codebuild_role.arn }
output "codepipeline_role_arn" { value = aws_iam_role.codepipeline_role.arn }
output "codedeploy_role_arn" { value = aws_iam_role.codedeploy_role.arn }

# Convenience exports
output "codebuild_role_name" { value = aws_iam_role.codebuild_role.name }
