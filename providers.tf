provider "aws" {
  region = try(var.replica_region, data.aws_region.current)
  alias  = "replica"
}

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = try(var.member_profile, "default")
  alias                    = "member"
}