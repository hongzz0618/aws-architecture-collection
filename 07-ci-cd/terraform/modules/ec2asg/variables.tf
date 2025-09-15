variable "instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "iam_instance_profile" { type = string }
variable "region" {
  type    = string
  default = "us-east-1"
}
