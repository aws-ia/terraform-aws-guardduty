terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
      configuration_aliases = [
        aws.member,
      ]
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4"
    }
  }
}
