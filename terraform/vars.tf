variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "aws access key"
  sensitive = true
}

variable "aws_secret_key" {
  description = "aws secret access key"
  sensitive = true
}

# vpc variable
variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.20.0.0/16"
}

# availability zones variable
data "aws_availability_zones" "available_zones" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

variable "git_commit_sha" {
  description = "Git commit SHA"
}

variable "app_name" {
    type = string
    default = "little-apples"
}

variable "app_environment" {
    type = string
    default = "prod"
}

