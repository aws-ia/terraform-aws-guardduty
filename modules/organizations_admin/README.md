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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_guardduty_organization_admin_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_admin_account) | resource |
| [aws_guardduty_organization_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_account_id"></a> [admin\_account\_id](#input\_admin\_account\_id) | AWS Organizations Admin Account Id. Defaults to `null` | `string` | `null` | no |
| <a name="input_auto_enable_org_config"></a> [auto\_enable\_org\_config](#input\_auto\_enable\_org\_config) | When this setting is enabled, all new accounts that are created in, or added to, the organization are added as a member accounts of the organization’s GuardDuty delegated administrator and GuardDuty is enabled in that AWS Region. | `bool` | `null` | no |
| <a name="input_auto_enable_organization_members"></a> [auto\_enable\_organization\_members](#input\_auto\_enable\_organization\_members) | Indicates the auto-enablement configuration of GuardDuty for the member accounts in the organization. Valid values are `ALL`, `NEW`, `NONE`. Defaults to `NEW`. | `string` | `"NEW"` | no |
| <a name="input_enable_kubernetes_protection"></a> [enable\_kubernetes\_protection](#input\_enable\_kubernetes\_protection) | Configure and enable Kubernetes audit logs as a data source for Kubernetes protection. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_enable_malware_protection"></a> [enable\_malware\_protection](#input\_enable\_malware\_protection) | Configure and enable Malware Protection as data source for EC2 instances with findings for the detector. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_enable_s3_protection"></a> [enable\_s3\_protection](#input\_enable\_s3\_protection) | Configure and enable S3 protection. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_guardduty_detector_id"></a> [guardduty\_detector\_id](#input\_guardduty\_detector\_id) | The detector ID of the GuardDuty account. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_delegated_admin_account"></a> [guardduty\_delegated\_admin\_account](#output\_guardduty\_delegated\_admin\_account) | AWS GuardDuty Delegated Admin account. |
| <a name="output_guardduty_organization_configuration"></a> [guardduty\_organization\_configuration](#output\_guardduty\_organization\_configuration) | AWS GuardDuty Organizations configuration. |
