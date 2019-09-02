# When ready to transfer to FCBH:
# - remove "bwflood" from the bucket name
# - change the profile and aws_profile to appropriate names. 


# Configure Terragrunt to automatically store tfstate files in an S3 bucket
#note: profile is needed, and must point to a profile configured via aws configure (~/.aws/credentials)
remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "bwflood-fcbh-terraform-state-nonprod"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    profile        = "contrib-kh-admin"
  }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
#Note: profile is definitely needed, not sure if aws_profile is needed... remove and see if it still works
inputs = {
  aws_region                   = "us-east-1"
  aws_profile                  = "contrib-kh-admin"
  tfstate_global_bucket        = "bwflood-fcbh-terraform-state-nonprod"
  tfstate_global_bucket_region = "us-east-1"
  profile                      = "contrib-kh-admin"
}
