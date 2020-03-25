# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//certificate"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region                = "us-east-1" # required for CloudFront certificate
  namespace                 = "dbp"
  stage                     = "prod"
  name                      = "cloudfront"
  domain_name               = "dbt.io"
  subject_alternative_names = ["4.dbt.io", "b4.dbt.io"]
}
