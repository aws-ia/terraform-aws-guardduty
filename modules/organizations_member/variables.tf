variable "guardduty_detector_id" {
  description = "The detector ID of the GuardDuty account. Defaults to `null`."
  type        = string
  default     = null
}

variable "master_account_id" {
  description = "AWS account ID for primary account. Defaults to `null`"
  type        = string
  default     = null
}

variable "member_config" {
  description = <<EOF
  Specifies the member account configuration:
  `enable`                     - Weather to enable GuardDuty in an Organizations Member Account. Defaults to `false`.
  `account_id`                 - The 13 digit ID number of the member account. Example: `123456789012`.
  `email`                      - Email address to send the invite for member account. Defaults to `null`.
  `invite`                     - Whether to invite the account to GuardDuty as a member. Defaults to `false`. To detect if an invitation needs to be (re-)sent, the Terraform state value is true based on a relationship_status of `Disabled` | `Enabled` |  `Invited` |  EmailVerificationInProgress.
  `invitation_message`         - Message for invitation. Defaults to `null`.
  `disable_email_notification` - Whether an email notification is sent to the accounts. Defaults to `false`.
  EOF
  type = list(object({
    enable                     = bool
    account_id                 = number
    email                      = string
    invite                     = bool
    invitation_message         = optional(string)
    disable_email_notification = optional(bool)
  }))
  default = null
}
