data "aws_caller_identity" "current" {}

module "delegated_admin" {
  source  = "aws-ia/guardduty/aws//modules/organizations_admin"
  version = "0.0.2"

  admin_account_id                 = data.aws_caller_identity.current.account_id
  auto_enable_organization_members = "NEW"
  guardduty_detector_id            = module.guardduty_detector.guardduty_detector.id

  enable_s3_protection         = true
  enable_kubernetes_protection = true
  enable_malware_protection    = true
}

module "guardduty_detector" {
  source  = "aws-ia/guardduty/aws"
  version = "0.0.2"

  enable_guardduty = true

  enable_s3_protection         = true
  enable_kubernetes_protection = true
  enable_malware_protection    = true
  enable_snapshot_retention    = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  tags                         = {}
}
