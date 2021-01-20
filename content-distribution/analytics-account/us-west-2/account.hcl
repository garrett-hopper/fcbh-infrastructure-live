# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "analytics"
  aws_account_id = "050878287951"
  aws_profile = "analytics"
}
