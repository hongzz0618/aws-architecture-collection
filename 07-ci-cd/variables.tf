variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  description = "Base name for project resources"
  default     = "simple-cicd-demo"
}

variable "github_owner" {
  description = "GitHub username or org"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to use"
  default     = "main"
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for CodePipeline"
  type        = string
  sensitive   = true
}
