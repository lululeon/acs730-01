variable "aws_region" {
  description = "Region to build in. LocalStack ignores it, real AWS does not."
  type        = string
  default     = "us-east-1"
}
variable "project" {
  description = "Name prefix for every resource."
  type        = string
  default     = "acs730-assn1"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,23}$", var.project))
    error_message = "project: 3-24 lowercase letters, digits, hyphens, starting with a letter."
  }
}
variable "owner" {
  description = "Your Seneca username. Tagged onto everything. No default on purpose."
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  # removed default cidr; would class with new dev/stg/prod layout.
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR, for example 10.42.0.0/16."
  }
}
variable "public_subnets" {
  description = "Public subnets to create, keyed by a short stable name."
  type = map(object({
    cidr_block = string
    az_index   = number
  }))
  # got rid of defaults from lab5.
}
variable "ingress_rules" {
  description = "Ingress rules for the web security group, rendered by a dynamic block."
  type = list(object({
    description = string
    port        = number
    cidr_blocks = list(string)
  }))
  default = [
    { description = "HTTP from anywhere", port = 80, cidr_blocks = ["0.0.0.0/0"] },
  ]
}
variable "instance_type" {
  description = "Instance type for the web server."
  type        = string
  default     = "t3.micro"
  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "Stay small: t3.micro or t3.small. The term budget is $50 in total."
  }
}

# no longer used, leftover from lab5.
# variable "create_artifact_bucket" {
#   description = "Unused legacy flag from lab5 (artifacts bucket removed for Academy SCP)."
#   type        = bool
#   default     = false
# }

variable "environment" {
  description = "Environment name (dev/staging/prod). Used to uniquify regional names like alarms."
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "ssm_parameter_name" {
  description = "Existing SSM parameter name to read (created out of band with put-parameter)."
  type        = string
}

variable "alarm_cpu_threshold" {
  description = "CPUUtilization percent that trips the CloudWatch alarm."
  type        = number
  default     = 80
}
