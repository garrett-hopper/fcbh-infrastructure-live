# member-account: dbp-dev

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
  namespace                   = "dbp"
  stage                       = "dev"
  name                        = "certificate"
  domain_name                 = "dbt.io"
  # note that this requires an AWS route53 zone accessible to this IAM user,
  # thus we create such in terragrunt elsewehre, even though it is not the actual
  # worldwide DNS zone (no SOA record)
  subject_alternative_names   = ["dev.v4.dbt.io"]
}
