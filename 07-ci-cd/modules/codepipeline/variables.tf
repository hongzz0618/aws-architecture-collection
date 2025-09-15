variable "project_name" {
  type = string
}
variable "artifact_bucket" {
  type = string
}
variable "service_role_arn" {
  type = string
}
variable "codebuild_project" {
  type = string
}
variable "github_owner" {
  type = string
}
variable "github_repo" {
  type = string
}
variable "github_branch" {
  type = string
}
variable "github_oauth_token" {
  type      = string
  sensitive = true
}
