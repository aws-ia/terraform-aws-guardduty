data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_guardduty_detector" "primary" {
  count = var.member_only ? 1 : 0
}

data "aws_caller_identity" "admin" {
  count = var.member_config != null ? 1 : 0
}

data "aws_iam_policy_document" "guardduty_bucket_policy" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  statement {
    sid = "Allow PutObject"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${module.s3_bucket[0].s3_bucket_arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow GetBucketLocation"
    actions = [
      "s3:GetBucketLocation"
    ]

    resources = [
      module.s3_bucket[0].s3_bucket_arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "guardduty_replica_bucket_policy" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  statement {
    sid = "Allow PutObject"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${module.replica_bucket[0].s3_bucket_arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow GetBucketLocation"
    actions = [
      "s3:GetBucketLocation"
    ]

    resources = [
      module.replica_bucket[0].s3_bucket_arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "guardduty_kms_policy" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  statement {
    sid = "Allow GuardDuty to encrypt findings"
    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow all users to modify/delete key (test only)"
    actions = [
      "kms:*"
    ]

    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

}

data "aws_iam_policy_document" "bucket_replication_assume_role" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "bucket_replication" {
  count = var.ipset_config != null || var.threatintelset_config != null || var.publish_to_s3 ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [module.s3_bucket[0].s3_bucket_arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = ["${module.s3_bucket[0].s3_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]

    resources = ["${module.replica_bucket[0].s3_bucket_arn}/*"] #tfsec:ignore:aws-iam-no-policy-wildcards # Required to access all objects in order do do the replication.
  }
}