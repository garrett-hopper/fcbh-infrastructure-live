# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "bibleis"
  aws_account_id = "529323115138"
  aws_profile = "bibleis"
}
