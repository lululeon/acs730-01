# AMI ids are regional and change whenever Amazon publishes a build, so a
# hardcoded one goes stale.
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

locals {
  # not using localstack - removed optionality via count, so no longer dealing with a list.
  # ami_id = data.aws_ami.al2023[0].id
  ami_id = data.aws_ami.al2023.id

  # keys() on a map returns sorted order, so this is stable across runs.
  first_subnet_key = keys(local.public_subnets)[0]
}

resource "aws_instance" "web" {
  ami                    = local.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[local.first_subnet_key].id
  vpc_security_group_ids = [aws_security_group.web.id]

  # SSM value is read via data source (Task 6). Kept out of the HTML on purpose.
  user_data = <<-EOT
    #!/bin/bash
    set -euo pipefail
    export APP_DB_PASSWORD='${data.aws_ssm_parameter.db_password.value}'
    dnf -y install nginx
    echo "<h1>ACS730 Assn1 - ${local.name}</h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT

  # The subnet and security group are implied by the references above; the
  # route table association is NOT, so Terraform is free to build the
  # instance first -- user_data then runs with no default route, dnf hangs,
  # and the instance comes up with no web server and no error.
  depends_on = [aws_route_table_association.public]

  tags = merge(local.common_tags, { Name = "${local.name}-web" })
}

# lab5 specific - not needed and messes up tf?
# # not using localstack - remove optionality via count
# resource "aws_s3_bucket" "artifacts" {
#   bucket        = "${local.name}-artifacts"
#   force_destroy = true

#   tags = merge(local.common_tags, { Name = "${local.name}-artifacts" })
# }
