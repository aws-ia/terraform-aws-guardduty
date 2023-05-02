provider "aws" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "standalone_guardduty" {
  #  source = "github.com/rodrigobersa/terraform-aws-guardduty"
  source = "../../../"

  enable_guardduty             = true
  enable_s3_protection         = true
  enable_kubernetes_protection = true
  enable_malware_protection    = true
  enable_snapshot_retention    = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  tags                         = {}
}