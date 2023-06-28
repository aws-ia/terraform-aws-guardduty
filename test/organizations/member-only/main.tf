provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "member"
  alias                    = "member"
}

data "aws_guardduty_detector" "primary" {}

module "member" {
  source = "../../../modules/organizations_member/"

  providers = {
    aws        = aws
    aws.member = aws.member
  }

  guardduty_detector_id = data.aws_guardduty_detector.primary.id

  member_config = [{
    enable     = true
    account_id = "123456789012"
    email      = "required@example.com"
    invite     = false
  }]
}
