provider "aws" {
  region = try(var.replica_region, data.aws_region.current)
  alias  = "replica"
}
