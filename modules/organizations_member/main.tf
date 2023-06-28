# provider "aws" {
#   alias = "member"
# }

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

resource "aws_guardduty_invite_accepter" "member" {
  for_each = var.member_config != null ? { for member in var.member_config : member.account_id => member if member.invite } : {}

  provider = aws.member

  detector_id       = aws_guardduty_detector.member[each.key].id
  master_account_id = var.master_account_id == null ? data.aws_caller_identity.current.account_id : var.master_account_id

  depends_on = [aws_guardduty_member.this]
}

resource "aws_guardduty_member" "this" {
  for_each = var.member_config != null ? { for member in var.member_config : member.account_id => member } : {}

  account_id                 = each.value.account_id
  detector_id                = var.guardduty_detector_id
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
