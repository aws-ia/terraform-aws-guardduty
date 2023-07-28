module "standalone_guardduty" {
  source  = "aws-ia/guardduty/aws"
  version = "0.0.2"

  enable_guardduty             = true
  enable_s3_protection         = true
  enable_kubernetes_protection = true
  enable_malware_protection    = true
  enable_snapshot_retention    = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  tags                         = {}
}
