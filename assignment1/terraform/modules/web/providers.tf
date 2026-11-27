provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Course = "ACS730"
      Lab    = "assn1"
      Owner  = var.owner
    }
  }
}
