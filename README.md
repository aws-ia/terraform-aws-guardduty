<!-- BEGIN_TF_DOCS -->
# Terraform Module for AWS GuardDuty

- [Terraform Module for AWS GuardDuty](#terraform-module-for-aws-guardduty)
  - [Overview Diagrams](#overview-diagrams)
    - [Stand-Alone](#stand-alone)
    - [Organizations](#organizations)
  - [Terraform Module](#terraform-module)
    - [Requirements](#requirements)
    - [Providers](#providers)
    - [Modules](#modules)
    - [Resources](#resources)
    - [Inputs](#inputs)
    - [Outputs](#outputs)

## Overview Diagrams

### Stand-Alone

![standalone-diagram](./docs/StandaloneGuardDuty\_v1.png)

### Organizations

![organizations-diagram](./docs/OrgGuardDuty\_v1.png)

## Terraform Module

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |
| <a name="provider_aws.replica"></a> [aws.replica](#provider\_aws.replica) | >= 4.47 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.8.2 |
| <a name="module_replica_bucket"></a> [replica\_bucket](#module\_replica\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.8.2 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.8.2 |

### Resources

| Name | Type |
|------|------|
| [aws_guardduty_detector.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_filter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_filter) | resource |
| [aws_guardduty_ipset.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_ipset) | resource |
| [aws_guardduty_publishing_destination.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_publishing_destination) | resource |
| [aws_guardduty_threatintelset.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_threatintelset) | resource |
| [aws_iam_policy.bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.guardduty_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.replica_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_object.ipset_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.threatintelset_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_replication_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.guardduty_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.guardduty_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.guardduty_replica_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_account_id"></a> [admin\_account\_id](#input\_admin\_account\_id) | AWS Organizations Admin Account Id. Defaults to `null` | `string` | `null` | no |
| <a name="input_enable_guardduty"></a> [enable\_guardduty](#input\_enable\_guardduty) | Enable monitoring and feedback reporting. Setting to false is equivalent to 'suspending' GuardDuty. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_enable_kubernetes_protection"></a> [enable\_kubernetes\_protection](#input\_enable\_kubernetes\_protection) | Configure and enable Kubernetes audit logs as a data source for Kubernetes protection. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_enable_malware_protection"></a> [enable\_malware\_protection](#input\_enable\_malware\_protection) | Configure and enable Malware Protection as data source for EC2 instances with findings for the detector. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_enable_s3_protection"></a> [enable\_s3\_protection](#input\_enable\_s3\_protection) | Configure and enable S3 protection. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_enable_snapshot_retention"></a> [enable\_snapshot\_retention](#input\_enable\_snapshot\_retention) | Enable EBS Snaptshot retention for 30 days, if any Findings exists. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_filter_config"></a> [filter\_config](#input\_filter\_config) | Specifies AWS GuardDuty Filter configuration.<br>  `name` - The name of the filter<br>  `rank` - Specifies the position of the filter in the list of current filters. Also specifies the order in which this filter is applied to the findings.<br>  `action` - Specifies the action that is to be applied to the findings that match the filter. Can be one of ARCHIVE or NOOP.<br>  `criterion` - Configuration block for `finding_criteria`. Composed by `field` and one or more of the following operators: `equals` \| `not_equals` \| `greater_than` \| `greater_than_or_equal` \| `less_than` \| `less_than_or_equal`. | <pre>list(object({<br>    name        = string<br>    description = optional(string)<br>    rank        = number<br>    action      = string<br>    criterion = list(object({<br>      field                 = string<br>      equals                = optional(list(string))<br>      not_equals            = optional(list(string))<br>      greater_than          = optional(string)<br>      greater_than_or_equal = optional(string)<br>      less_than             = optional(string)<br>      less_than_or_equal    = optional(string)<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | Specifies the frequency of notifications sent for subsequent finding occurrences. If the detector is a GuardDuty member account, the value is determined by the GuardDuty primary account and cannot be modified. For standalone and GuardDuty primary accounts, it must be configured in Terraform to enable drift detection. Valid values for standalone and primary accounts: `FIFTEEN_MINUTES`, `ONE_HOUR`, `SIX_HOURS`. Defaults to `SIX_HOURS`. | `string` | `"FIFTEEN_MINUTES"` | no |
| <a name="input_guardduty_bucket_acl"></a> [guardduty\_bucket\_acl](#input\_guardduty\_bucket\_acl) | Canned ACL to apply to the bucket. Valid values are `private` \| `public-read` \| `public-read-write` \| `aws-exec-read` \| `authenticated-read` \| `bucket-owner-read` \| `bucket-owner-full-control`. Defaults to `null`. | `string` | `null` | no |
| <a name="input_guardduty_s3_bucket"></a> [guardduty\_s3\_bucket](#input\_guardduty\_s3\_bucket) | Name of the S3 Bucket for GuardDuty. Defaults to `null`. | `string` | `null` | no |
| <a name="input_ipset_config"></a> [ipset\_config](#input\_ipset\_config) | Specifies AWS GuardDuty IPSet configuration.<br>  `activate` - Specifies whether GuardDuty is to start using the uploaded IPSet.<br>  `name` - The friendly name to identify the IPSet. <br>  `format` - The format of the file that contains the IPSet. Valid values: `TXT` \| `STIX` \| `OTX_CSV` \| `ALIEN_VAULT` \| `PROOF_POINT` \| `FIRE_EYE`. <br>  `content`- Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. Example: `10.0.0.0/8\n`.<br>  `key` - Name of the object once it is in the bucket. | <pre>list(object({<br>    activate = bool<br>    name     = string<br>    format   = string<br>    content  = string<br>    key      = string<br>  }))</pre> | `null` | no |
| <a name="input_publish_to_s3"></a> [publish\_to\_s3](#input\_publish\_to\_s3) | n/a | `bool` | `false` | no |
| <a name="input_publishing_config"></a> [publishing\_config](#input\_publishing\_config) | n/a | <pre>list(object({<br>    destination_arn  = string<br>    kms_key_arn      = string<br>    destination_type = optional(string)<br>  }))</pre> | <pre>[<br>  {<br>    "destination_arn": null,<br>    "destination_type": "S3",<br>    "kms_key_arn": null<br>  }<br>]</pre> | no |
| <a name="input_replica_region"></a> [replica\_region](#input\_replica\_region) | n/a | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value map of resource tags. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. Defaults to `{}`. | `map(any)` | `{}` | no |
| <a name="input_threatintelset_config"></a> [threatintelset\_config](#input\_threatintelset\_config) | Specifies AWS GuardDuty ThreatIntelSet configuration.<br>  `activate` - Specifies whether GuardDuty is to start using the uploaded ThreatIntelSet.<br>  `name` - The friendly name to identify the ThreatIntelSet. <br>  `format` - The format of the file that contains the ThreatIntelSet. Valid values: `TXT` \| `STIX` \| `OTX_CSV` \| `ALIEN_VAULT` \| `PROOF_POINT` \| `FIRE_EYE`.<br>  `content`- Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. Example: `10.0.0.0/8\n`. <br>  `key` - Name of the object once it is in the bucket. <br>  `object_acl`- Canned ACL to apply to the object. Valid values are `private` \| `public-read` \| `public-read-write` \| `aws-exec-read` \| `authenticated-read` \| `bucket-owner-read` \| `bucket-owner-full-control`. | <pre>list(object({<br>    activate   = bool<br>    name       = string<br>    format     = string<br>    content    = string<br>    key        = string<br>    object_acl = string<br>  }))</pre> | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_detector"></a> [guardduty\_detector](#output\_guardduty\_detector) | AWS GuardDuty Detector. |
| <a name="output_guardduty_filter"></a> [guardduty\_filter](#output\_guardduty\_filter) | AWS GuardDuty Findings Filters definition. |
| <a name="output_guardduty_ipset"></a> [guardduty\_ipset](#output\_guardduty\_ipset) | AWS GuardDuty trusted IPSet configuration. |
| <a name="output_guardduty_kms_key"></a> [guardduty\_kms\_key](#output\_guardduty\_kms\_key) | Amazon KMS Key created to encrypt AWS GuardDuty's S3 Bucket. |
| <a name="output_guardduty_publishing"></a> [guardduty\_publishing](#output\_guardduty\_publishing) | AWS GuardDuty Publishing destination to export findings. |
| <a name="output_guardduty_s3_bucket"></a> [guardduty\_s3\_bucket](#output\_guardduty\_s3\_bucket) | Amazon S3 Bucket created for AWS GuardDuty. |
| <a name="output_guardduty_threatintelset"></a> [guardduty\_threatintelset](#output\_guardduty\_threatintelset) | AWS GuardDuty known ThreatIntelSet configuration. |
<!-- END_TF_DOCS -->
