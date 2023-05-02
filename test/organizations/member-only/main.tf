provider "aws" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "member_guardduty" {
  #  source = "github.com/rodrigobersa/terraform-aws-guardduty"
  source = "../../../"

  member_only    = true
  member_profile = "member"
  member_config = [{
    enable     = true
    account_id = ""
    email      = "required@example.com"
    invite     = false
  }]
}
