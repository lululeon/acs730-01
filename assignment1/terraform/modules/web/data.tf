# Created once out of band (see REPORT.md). Data source only — no aws_ssm_parameter resource.
data "aws_ssm_parameter" "db_password" {
  name            = var.ssm_parameter_name
  with_decryption = true
}
