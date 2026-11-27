locals {
  # Single naming prefix for the module — use "${local.name}-vpc", "${local.name}-web", etc.
  name = "${var.project}-${var.owner}-${var.environment}"

  # Single source of truth for "where did this run actually point".
  provider_target = "aws (${data.aws_region.current.name})"

  # Fold the AZ lookup in here, so resource blocks are just assignments.
  public_subnets = {
    for key, cfg in var.public_subnets : key => {
      cidr_block        = cfg.cidr_block
      availability_zone = data.aws_availability_zones.available.names[cfg.az_index]
    }
  }

  common_tags = {
    Managed     = "terraform"
    Lab         = "assn1"
    Environment = var.environment
  }
}
