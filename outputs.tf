output "guardduty_detector" {
  description = "AWS GuardDuty Detector."
  value       = aws_guardduty_detector.primary
}

output "guardduty_filter" {
  description = "AWS GuardDuty Findings Filters definition."
  value       = aws_guardduty_filter.this
}

output "guardduty_ipset" {
  description = "AWS GuardDuty trusted IPSet configuration."
  value       = aws_guardduty_ipset.this
}

output "guardduty_threatintelset" {
  description = "AWS GuardDuty known ThreatIntelSet configuration."
  value       = aws_guardduty_threatintelset.this
}

output "guardduty_publishing" {
  description = "AWS GuardDuty Publishing destination to export findings."
  value       = aws_guardduty_publishing_destination.this
}

output "guardduty_s3_bucket" {
  description = "Amazon S3 Bucket created for AWS GuardDuty."
  value       = module.s3_bucket
}

output "guardduty_kms_key" {
  description = "Amazon KMS Key created to encrypt AWS GuardDuty's S3 Bucket."
  value       = aws_kms_key.guardduty_key
}