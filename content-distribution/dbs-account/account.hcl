# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "dbs"
  aws_account_id = "869054869504"
  aws_profile = "dbs"
}
