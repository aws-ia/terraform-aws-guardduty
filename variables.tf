variable "member_profile" {
  type = string
  default = null
}

variable "replica_region" {
  type = string
  default = null
}

variable "enable_guardduty" {
  description = "Enable monitoring and feedback reporting. Setting to false is equivalent to 'suspending' GuardDuty. Defaults to `true`."
  type        = bool
  default     = true
}

variable "enable_s3_protection" {
  description = "Configure and enable S3 protection. Defaults to `true`."
  type        = bool
  default     = true
}

variable "enable_kubernetes_protection" {
  description = "Configure and enable Kubernetes audit logs as a data source for Kubernetes protection. Defaults to `true`."
  type        = bool
  default     = true
}

variable "enable_malware_protection" {
  description = "Configure and enable Malware Protection as data source for EC2 instances with findings for the detector. Defaults to `true`."
  type        = bool
  default     = true
}

variable "enable_snapshot_retention" {
  description = "Enable EBS Snaptshot retention for 30 days, if any Findings exists. Defaults to `false`."
  type        = bool
  default     = false
}

variable "finding_publishing_frequency" {
  description = "Specifies the frequency of notifications sent for subsequent finding occurrences. If the detector is a GuardDuty member account, the value is determined by the GuardDuty primary account and cannot be modified. For standalone and GuardDuty primary accounts, it must be configured in Terraform to enable drift detection. Valid values for standalone and primary accounts: `FIFTEEN_MINUTES`, `ONE_HOUR`, `SIX_HOURS`. Defaults to `SIX_HOURS`."
  type        = string
  default     = "FIFTEEN_MINUTES"
}

variable "auto_enable_org_config" {
  description = "When this setting is enabled, all new accounts that are created in, or added to, the organization are added as a member accounts of the organization’s GuardDuty delegated administrator and GuardDuty is enabled in that AWS Region."
  type        = bool
  default     = false
}

variable "admin_account_id" {
  description = "AWS Organizations Admin Account Id. Defaults to `null`"
  type        = string
  default     = null
}

variable "member_only" {
  type = bool
  default = false
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

variable "filter_config" {
  description = <<EOF
  Specifies AWS GuardDuty Filter configuration.
  `name` - The name of the filter
  `rank` - Specifies the position of the filter in the list of current filters. Also specifies the order in which this filter is applied to the findings.
  `action` - Specifies the action that is to be applied to the findings that match the filter. Can be one of ARCHIVE or NOOP.
  `criterion` - Configuration block for `finding_criteria`. Composed by `field` and one or more of the following operators: `equals` | `not_equals` | `greater_than` | `greater_than_or_equal` | `less_than` | `less_than_or_equal`.
  EOF
  type = list(object({
    name        = string
    description = optional(string)
    rank        = number
    action      = string
    criterion = list(object({
      field                 = string
      equals                = optional(list(string))
      not_equals            = optional(list(string))
      greater_than          = optional(string)
      greater_than_or_equal = optional(string)
      less_than             = optional(string)
      less_than_or_equal    = optional(string)
    }))
  }))
  default = null
}

variable "ipset_config" {
  description = <<EOF
  Specifies AWS GuardDuty IPSet configuration.
  `activate` - Specifies whether GuardDuty is to start using the uploaded IPSet.
  `name` - The friendly name to identify the IPSet. 
  `format` - The format of the file that contains the IPSet. Valid values: `TXT` | `STIX` | `OTX_CSV` | `ALIEN_VAULT` | `PROOF_POINT` | `FIRE_EYE`. 
  `content`- Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. Example: `10.0.0.0/8\n`.
  `key` - Name of the object once it is in the bucket.
  EOF
  type = list(object({
    activate = bool
    name     = string
    format   = string
    content  = string
    key      = string
  }))
  default = null
}

variable "threatintelset_config" {
  description = <<EOF
  Specifies AWS GuardDuty ThreatIntelSet configuration.
  `activate` - Specifies whether GuardDuty is to start using the uploaded ThreatIntelSet.
  `name` - The friendly name to identify the ThreatIntelSet. 
  `format` - The format of the file that contains the ThreatIntelSet. Valid values: `TXT` | `STIX` | `OTX_CSV` | `ALIEN_VAULT` | `PROOF_POINT` | `FIRE_EYE`.
  `content`- Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. Example: `10.0.0.0/8\n`. 
  `key` - Name of the object once it is in the bucket. 
  `object_acl`- Canned ACL to apply to the object. Valid values are `private` | `public-read` | `public-read-write` | `aws-exec-read` | `authenticated-read` | `bucket-owner-read` | `bucket-owner-full-control`.
  EOF
  type = list(object({
    activate   = bool
    name       = string
    format     = string
    content    = string
    key        = string
    object_acl = string
  }))
  default = null
}

variable "publish_to_s3" {
  type    = bool
  default = false
}

variable "publishing_config" {
  description = ""
  type = list(object({
    destination_arn  = string
    kms_key_arn      = string
    destination_type = optional(string)
  }))
  default = [{
    destination_arn  = null
    kms_key_arn      = null
    destination_type = "S3"
  }]
}

variable "guardduty_s3_bucket" {
  description = "Name of the S3 Bucket for GuardDuty. Defaults to `null`."
  type        = string
  default     = null
}

variable "guardduty_bucket_acl" {
  description = "Canned ACL to apply to the bucket. Valid values are `private` | `public-read` | `public-read-write` | `aws-exec-read` | `authenticated-read` | `bucket-owner-read` | `bucket-owner-full-control`. Defaults to `private`."
  type        = string
  default     = "private"
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. Defaults to `{}`."
  type        = map(any)
  default     = {}
}