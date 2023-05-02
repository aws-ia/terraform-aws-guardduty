locals {
  snapshot_preservation = var.enable_snapshot_retention ? "'RETENTION_WITH_FINDING'" : "'NO_RETENTION'"
  tags = {
    Example    = "${basename(path.cwd)}"
    Repository = "https://github.com/rodrigobersa/terraform-aws-guardduty"
  }
}