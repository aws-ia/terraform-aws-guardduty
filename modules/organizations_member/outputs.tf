##################################################
# GuardDuty Organizations Detector Member
##################################################
output "guardduty_member_detector" {
  description = "AWS GuardDuty member detector."
  value       = aws_guardduty_detector.member
}

##################################################
# GuardDuty Organizations Invite
##################################################
output "guardduty_invite_accepter" {
  description = "AWS GuardDuty Detector invite."
  value       = aws_guardduty_invite_accepter.member
}

##################################################
# GuardDuty Organizations Member
##################################################
output "guardduty_member_configuration" {
  description = "AWS GuardDuty member configuration."
  value       = aws_guardduty_member.this
}
