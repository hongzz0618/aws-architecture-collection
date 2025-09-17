variable "project" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_ids" {
  type = list(string)
}
