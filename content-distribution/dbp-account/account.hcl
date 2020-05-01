# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "dbp"
  aws_account_id = "596282610570"
  aws_profile = "dbp"
}
