output "guardduty_delegated_admin_account" {
  description = "AWS GuardDuty Delegated Admin account."
  value       = aws_guardduty_organization_admin_account.this
}

output "guardduty_organization_configuration" {
  description = "AWS GuardDuty Organizations configuration."
  value       = aws_guardduty_organization_configuration.this
}
