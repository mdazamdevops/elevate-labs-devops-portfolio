variable "aws_region" {
  default = "ap-south-1"
}

variable "gcp_region" {
  default = "us-central1"
}

variable "gcp_zone" {
  default = "us-central1-a"
}

variable "gcp_project_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}