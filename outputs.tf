##################################################
# GuardDuty Detector
##################################################
output "guardduty_detector" {
  description = "AWS GuardDuty Detector."
  value       = aws_guardduty_detector.primary
}

##################################################
# GuardDuty Filter
##################################################
output "guardduty_filter" {
  description = "AWS GuardDuty Findings Filters definition."
  value       = aws_guardduty_filter.this
}

##################################################
# GuardDuty IPSet
##################################################
output "guardduty_ipset" {
  description = "AWS GuardDuty trusted IPSet configuration."
  value       = aws_guardduty_ipset.this
}

##################################################
# GuardDuty Threatintelset
##################################################
output "guardduty_threatintelset" {
  description = "AWS GuardDuty known ThreatIntelSet configuration."
  value       = aws_guardduty_threatintelset.this
}

##################################################
# GuardDuty Publishing
##################################################
output "guardduty_publishing" {
  description = "AWS GuardDuty Publishing destination to export findings."
  value       = aws_guardduty_publishing_destination.this
}

output "guardduty_s3_bucket" {
  description = "Amazon S3 Bucket created for AWS GuardDuty."
  value       = module.s3_bucket
}

output "guardduty_replica_bucket" {
  description = "Amazon S3 Replica Bucket created for AWS GuardDuty."
  value       = module.replica_bucket
}
output "guardduty_log_bucket" {
  description = "Amazon S3 Log Bucket created for AWS GuardDuty."
  value       = module.log_bucket
}

##################################################
# KMS Key
##################################################
output "guardduty_kms_key" {
  description = "Amazon KMS Key created to encrypt AWS GuardDuty's S3 Bucket."
  value       = aws_kms_key.guardduty_key
}

output "guardduty_kms_replica_key" {
  description = "Amazon KMS Key created to encrypt AWS GuardDuty's S3 Replica Bucket."
  value       = aws_kms_key.replica_key
}
