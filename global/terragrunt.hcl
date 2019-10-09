# root of global

# # TODO: the bucket name must be globally unique. REPLACE bwf with fcbh (lower case) when ready
remote_state {
  backend = "s3"
  config = {
    bucket = "bwf-org-terraform-state"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = {
  # aws_region                        = "us-east-1"
  # aws_profile                       = "prod"
  # tfstate_global_bucket             = "terragrunt-example-terraform-state-prod"
  # tfstate_global_bucket_region      = "us-east-1"
  namespace                         = "fcbh"
  name                              = "dbp"
  # stage                             = "prod"
  # iam_users_accessing_prod          = ["bwflood"]
  # role_arn_referencing_prod_account = { "dbp@prod" = "arn:aws:iam::627672411722:role/OrganizationAccountAccessRole" }
}


