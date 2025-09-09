# CodeBuild role
resource "aws_iam_role" "codebuild" {
  name = "example-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect="Allow", Principal={ Service="codebuild.amazonaws.com"}, Action="sts:AssumeRole"}]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[
      { Effect="Allow", Action=["s3:GetObject","s3:PutObject","s3:GetObjectVersion","s3:GetBucketLocation"], Resource="${var.artifact_bucket_arn}/*" },
      { Effect="Allow", Action=["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"], Resource="*" }
    ]
  })
}

# CodePipeline role
resource "aws_iam_role" "codepipeline" {
  name = "example-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect="Allow", Principal={ Service="codepipeline.amazonaws.com" }, Action="sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = aws_iam_role.codepipeline.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[
      { Effect="Allow", Action=["s3:*"], Resource="${var.artifact_bucket_arn}/*" },
      { Effect="Allow", Action=["codebuild:StartBuild","codebuild:BatchGetBuilds"], Resource="*" },
      { Effect="Allow", Action=["codedeploy:*"], Resource="*" }
    ]
  })
}

# CodeDeploy service role
resource "aws_iam_role" "codedeploy" {
  name = "example-codedeploy-role"
  assume_role_policy = jsonencode({
    Version="2012-10-17",
    Statement=[{ Effect="Allow", Principal={ Service="codedeploy.amazonaws.com" }, Action="sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "codedeploy_policy" {
  role = aws_iam_role.codedeploy.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[{ Effect="Allow", Action=["autoscaling:*","ec2:*","s3:*","iam:PassRole","cloudwatch:*"], Resource="*" }]
  })
}

# EC2 instance role for CodeDeploy agent and S3 access
resource "aws_iam_role" "ec2_instance" {
  name = "example-ec2-instance-role"
  assume_role_policy = jsonencode({
    Version="2012-10-17",
    Statement=[{ Effect="Allow", Principal={ Service="ec2.amazonaws.com" }, Action="sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "ec2_instance_policy" {
  role = aws_iam_role.ec2_instance.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[
      { Effect="Allow", Action=["s3:GetObject","s3:ListBucket"], Resource=["${var.artifact_bucket_arn}","${var.artifact_bucket_arn}/*"] },
      { Effect="Allow", Action=["ec2:Describe*"], Resource="*" },
      { Effect="Allow", Action=["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"], Resource="*" }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "example-ec2-instance-profile"
  role = aws_iam_role.ec2_instance.name
}

output "codebuild_role_arn" { value = aws_iam_role.codebuild.arn }
output "codepipeline_role_arn" { value = aws_iam_role.codepipeline.arn }
output "codedeploy_role_arn" { value = aws_iam_role.codedeploy.arn }
output "instance_profile_name" { value = aws_iam_instance_profile.ec2_profile.name }
output "ec2_instance_role_name" { value = aws_iam_role.ec2_instance.name }
