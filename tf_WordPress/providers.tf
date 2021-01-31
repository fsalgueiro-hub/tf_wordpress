# Providers ;)
provider "aws" {
  profile = var.profile
  region  = var.region-wordpress
  alias   = "region-wordpress"
}

