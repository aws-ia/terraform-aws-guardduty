## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_delegated_admin"></a> [delegated\_admin](#module\_delegated\_admin) | ../../../modules/organizations_admin/ | n/a |
| <a name="module_guardduty_detector"></a> [guardduty\_detector](#module\_guardduty\_detector) | ../../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delegated_admin"></a> [delegated\_admin](#output\_delegated\_admin) | AWS GuardDuty Detector Delegated Admin. |
