#####################################
# GuardDuty Detector                #
#####################################
resource "aws_guardduty_detector" "primary" {
  count  = var.member_only ? 0 : 1
  enable = var.enable_guardduty

  datasources {
    s3_logs {
      enable = var.enable_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.enable_kubernetes_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.enable_malware_protection
        }
      }
    }
  }

  finding_publishing_frequency = var.finding_publishing_frequency

  tags = merge(
    local.tags,
    var.tags
  )

  provisioner "local-exec" {
    command = "aws guardduty update-malware-scan-settings --detector-id ${self.id} --ebs-snapshot-preservation ${local.snapshot_preservation}"
  }
}

#####################################
# GuardDuty Organizations Admin     #
#####################################
resource "aws_guardduty_organization_admin_account" "this" {
  count            = var.admin_account_id == null ? 0 : 1
  admin_account_id = var.admin_account_id
}

resource "aws_guardduty_organization_configuration" "admin" {
  count = var.admin_account_id == null ? 0 : 1

  auto_enable = var.auto_enable_org_config
  detector_id = aws_guardduty_detector.primary[0].id

  datasources {
    s3_logs {
      auto_enable = var.enable_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.enable_kubernetes_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = var.enable_malware_protection
        }
      }
    }
  }
}

#####################################
# GuardDuty Organizations Member    #
#####################################
resource "aws_guardduty_detector" "member" {
  #checkov:skip=CKV_AWS_238:Conditional argument for member accounts.
  #checkov:skip=CKV2_AWS_3:Org/Region will be defined by the Admin account.
  for_each = var.member_config != null ? { for member in var.member_config : member.account_id => member } : {}
  provider = aws.member

  enable = each.value.enable
}

resource "aws_guardduty_member" "member" {
  for_each = var.member_config != null ? { for member in var.member_config : member.account_id => member } : {}

  account_id                 = each.value.account_id
  detector_id                = var.member_only ? data.aws_guardduty_detector.primary[0].id : aws_guardduty_detector.primary[0].id
  email                      = each.value.email
  invite                     = each.value.invite
  invitation_message         = each.value.invitation_message
  disable_email_notification = each.value.disable_email_notification

  lifecycle {
    ignore_changes = [
      # For why this is necessary, see https://github.com/hashicorp/terraform-provider-aws/issues/8206
      invite,
      disable_email_notification,
      invitation_message,
    ]
  }

  provisioner "local-exec" {
    command = "aws guardduty disassociate-members --detector-id ${self.detector_id} --account-ids ${self.account_id}"
    when    = destroy
  }
}

resource "aws_guardduty_invite_accepter" "member" {
  for_each = var.member_config != null ? { for member in var.member_config : member.account_id => member if member.invite } : {}
  provider = aws.member

  detector_id       = aws_guardduty_detector.member[each.key].id
  master_account_id = var.member_only ? data.aws_caller_identity.current.account_id : aws_guardduty_detector.primary[0].account_id

  depends_on = [aws_guardduty_member.member]
}

#####################################
# GuardDuty Filter                  #
#####################################
resource "aws_guardduty_filter" "this" {
  for_each = var.enable_guardduty && var.filter_config != null ? { for filter in var.filter_config : filter.name => filter } : {}

  detector_id = aws_guardduty_detector.primary[0].id

  name        = each.value.name
  action      = each.value.action
  rank        = each.value.rank
  description = each.value.description

  finding_criteria {
    dynamic "criterion" {
      for_each = each.value.criterion
      content {
        field                 = criterion.value.field
        equals                = criterion.value.equals
        not_equals            = criterion.value.not_equals
        greater_than          = criterion.value.greater_than
        greater_than_or_equal = criterion.value.greater_than_or_equal
        less_than             = criterion.value.less_than
        less_than_or_equal    = criterion.value.less_than_or_equal
      }
    }
  }

  tags = merge(
    local.tags,
    var.tags
  )
}

#####################################
# GuardDuty IPSet                   #
#####################################
resource "aws_guardduty_ipset" "this" {
  for_each = var.enable_guardduty && var.ipset_config != null ? { for ipset in var.ipset_config : ipset.name => ipset } : {}

  detector_id = aws_guardduty_detector.primary[0].id

  activate = each.value.activate
  name     = each.value.name
  format   = each.value.format
  location = "https://s3.amazonaws.com/${aws_s3_object.ipset_object[each.key].bucket}/${each.value.key}"

  tags = merge(
    local.tags,
    var.tags
  )
}

resource "aws_s3_object" "ipset_object" {
  for_each = var.enable_guardduty && var.ipset_config != null ? { for ipset in var.ipset_config : ipset.name => ipset } : {}

  bucket = var.guardduty_s3_bucket == null ? module.s3_bucket[0].s3_bucket_id : var.guardduty_s3_bucket

  content = each.value.content
  key     = each.value.key

  tags = merge(
    local.tags,
    var.tags
  )
}

#####################################
# GuardDuty ThreatIntelSet          #
#####################################
resource "aws_guardduty_threatintelset" "this" {
  for_each = var.enable_guardduty && var.threatintelset_config != null ? { for threatintelset in var.threatintelset_config : threatintelset.name => threatintelset } : {}

  detector_id = aws_guardduty_detector.primary[0].id

  activate = each.value.activate
  name     = each.value.name
  format   = each.value.format
  location = "https://s3.amazonaws.com/${aws_s3_object.threatintelset_object[each.key].bucket}/${each.value.key}"

  tags = merge(
    local.tags,
    var.tags
  )
}

resource "aws_s3_object" "threatintelset_object" {
  for_each = var.enable_guardduty && var.threatintelset_config != null ? { for threatintelset in var.threatintelset_config : threatintelset.name => threatintelset } : {}

  bucket = var.guardduty_s3_bucket == null ? module.s3_bucket[0].s3_bucket_id : var.guardduty_s3_bucket

  content = each.value.content
  key     = each.value.key

  tags = merge(
    local.tags,
    var.tags
  )
}

#####################################
# GuardDuty Publishing Destination  #
#####################################
resource "aws_guardduty_publishing_destination" "this" {
  for_each = var.enable_guardduty && var.publish_to_s3 ? { for destination in var.publishing_config : destination.destination_type => destination } : {}

  detector_id      = aws_guardduty_detector.primary[0].id
  destination_arn  = each.value.destination_arn == null ? module.s3_bucket[0].s3_bucket_arn : each.value.destination_arn
  kms_key_arn      = each.value.kms_key_arn == null ? aws_kms_key.guardduty_key[0].arn : each.value.kms_key_arn
  destination_type = each.value.destination_type

  depends_on = [
    module.s3_bucket,
    aws_kms_key.guardduty_key
  ]
}

#####################################
# Support Resources                 #
#####################################
resource "random_string" "this" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  length  = 8
  upper   = false
  special = false
}

#####################################
# KMS Key                           #
#####################################
resource "aws_kms_key" "guardduty_key" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  description             = "AWS KMS Key for Amazon GuardDuty Bucket encryption."
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.guardduty_kms_policy[0].json
  is_enabled              = true
  enable_key_rotation     = true
  multi_region            = true

  tags = merge(
    local.tags,
    var.tags
  )
}

resource "aws_kms_key" "replica_key" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  provider = aws.replica

  description             = "AWS KMS Key for Amazon GuardDuty Replica Bucket encryption."
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true

  tags = merge(
    local.tags,
    var.tags
  )
}

#####################################
# IAM                               #
#####################################
resource "aws_iam_role" "bucket_replication" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  name               = "guardduty-bucket-replication-${random_string.this[0].result}-role"
  assume_role_policy = data.aws_iam_policy_document.bucket_replication_assume_role[0].json
}

resource "aws_iam_policy" "bucket_replication" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  name   = "guardduty-bucket-replication-${random_string.this[0].result}-policy"
  policy = data.aws_iam_policy_document.bucket_replication[0].json
}

resource "aws_iam_role_policy_attachment" "replication" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  role       = aws_iam_role.bucket_replication[0].name
  policy_arn = aws_iam_policy.bucket_replication[0].arn
}

#####################################
# S3 Buckets                        #
#####################################
module "s3_bucket" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = var.guardduty_s3_bucket == null ? "guardduty-${data.aws_caller_identity.current.account_id}-${random_string.this[0].result}-bucket" : var.guardduty_s3_bucket
  acl    = var.guardduty_bucket_acl

  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.guardduty_bucket_policy[0].json
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    status     = true
    mfa_delete = false
  }

  logging = {
    target_bucket = module.log_bucket[0].s3_bucket_id
    target_prefix = "log/"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.guardduty_key[0].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  replication_configuration = {
    role = aws_iam_role.bucket_replication[0].arn

    rules = [
      {
        status = "Enabled"

        source_selection_criteria = {
          replica_modifications = {
            status = "Enabled"
          }
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        delete_marker_replication = true

        destination = {
          bucket             = module.replica_bucket[0].s3_bucket_arn
          storage_class      = "STANDARD"
          replica_kms_key_id = aws_kms_key.replica_key[0].arn
          account_id         = data.aws_caller_identity.current.account_id
          access_control_translation = {
            owner = "Destination"
          }

          replication_time = {
            status  = "Enabled"
            minutes = 15
          }

          metrics = {
            status  = "Enabled"
            minutes = 15
          }
        }
      },
    ]
  }

  tags = merge(
    local.tags,
    var.tags
  )
  
  depends_on = [
    module.replica_bucket
  ]
}

module "replica_bucket" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  providers = {
    aws = aws.replica
  }

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = var.guardduty_s3_bucket == null ? "guardduty-${data.aws_caller_identity.current.account_id}-${random_string.this[0].result}-replica-bucket" : var.guardduty_s3_bucket
  acl    = var.guardduty_bucket_acl

  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.guardduty_replica_bucket_policy[0].json
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.guardduty_key[0].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = merge(
    local.tags,
    var.tags
  )
}

module "log_bucket" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = var.guardduty_s3_bucket == null ? "guardduty-${data.aws_caller_identity.current.account_id}-${random_string.this[0].result}-log-bucket" : var.guardduty_s3_bucket
  acl    = "log-delivery-write"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.guardduty_key[0].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = merge(
    local.tags,
    var.tags
  )
}
