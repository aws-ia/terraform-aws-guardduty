## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |
| <a name="provider_aws.member"></a> [aws.member](#provider\_aws.member) | >= 4.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_guardduty_detector.member](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_invite_accepter.member](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_invite_accepter) | resource |
| [aws_guardduty_member.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_guardduty_detector_id"></a> [guardduty\_detector\_id](#input\_guardduty\_detector\_id) | The detector ID of the GuardDuty account. Defaults to `null`. | `string` | `null` | no |
| <a name="input_master_account_id"></a> [master\_account\_id](#input\_master\_account\_id) | AWS account ID for primary account. Defaults to `null` | `string` | `null` | no |
| <a name="input_member_config"></a> [member\_config](#input\_member\_config) | Specifies the member account configuration:<br>  `enable`                     - Weather to enable GuardDuty in an Organizations Member Account. Defaults to `false`. <br>  `account_id`                 - The 13 digit ID number of the member account. Example: `123456789012`.<br>  `email`                      - Email address to send the invite for member account. Defaults to `null`.<br>  `invite`                     - Whether to invite the account to GuardDuty as a member. Defaults to `false`. To detect if an invitation needs to be (re-)sent, the Terraform state value is true based on a relationship\_status of `Disabled` \| `Enabled` \|  `Invited` \|  EmailVerificationInProgress.<br>  `invitation_message`         - Message for invitation. Defaults to `null`.<br>  `disable_email_notification` - Whether an email notification is sent to the accounts. Defaults to `false`. | <pre>list(object({<br>    enable                     = bool<br>    account_id                 = number<br>    email                      = string<br>    invite                     = bool<br>    invitation_message         = optional(string)<br>    disable_email_notification = optional(bool)<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_invite_accepter"></a> [guardduty\_invite\_accepter](#output\_guardduty\_invite\_accepter) | AWS GuardDuty Detector invite. |
| <a name="output_guardduty_member_configuration"></a> [guardduty\_member\_configuration](#output\_guardduty\_member\_configuration) | AWS GuardDuty member configuration. |
| <a name="output_guardduty_member_detector"></a> [guardduty\_member\_detector](#output\_guardduty\_member\_detector) | AWS GuardDuty member detector. |
