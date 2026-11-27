terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  # per lessons learned lab3/lab6 - wire in a backend:
  backend "s3" {
    bucket       = "acs730-tfstate-946258861229-946258861229-us-east-1-an"
    key          = "assn1/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

# don't want tons of files, just put everything here.
locals {
  owner      = "lluttero"
  aws_region = "us-east-1"
  common_tags = {
    Course = "ACS730"
    Lab    = "assn1"
    Owner  = local.owner
  }
}

provider "aws" {
  region = local.aws_region
  default_tags {
    tags = local.common_tags
  }
}


module "web" {
  # use the spec for the web vm
  source = "../modules/web"

  project     = "acs730-assn1"
  owner       = local.owner
  environment = "dev"

  vpc_cidr = "10.10.0.0/16"
  public_subnets = {
    a = { cidr_block = "10.10.1.0/24", az_index = 0 }
    b = { cidr_block = "10.10.2.0/24", az_index = 1 }
  }

  instance_type       = "t3.micro"
  ssm_parameter_name  = "/acs730/assn1/db_password"
  alarm_cpu_threshold = 80
}