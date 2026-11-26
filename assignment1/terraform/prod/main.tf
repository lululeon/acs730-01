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
    key          = "assn1/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

module "web" {
  # use the spec for the web vm
  source = "../modules/web"

  project     = "acs730-assn1"
  owner       = var.owner
  environment = "prod"

  vpc_cidr = "10.30.0.0/16"
  public_subnets = {
    a = { cidr_block = "10.30.1.0/24", az_index = 0 }
    b = { cidr_block = "10.30.2.0/24", az_index = 1 }
  }

  instance_type          = "t3.micro"
  create_artifact_bucket = true
  ssm_parameter_name     = "/acs730/assn1/prod/db_password"
  alarm_cpu_threshold    = 80
}

