# member-account: dbp (596282610570)

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//vpc"
  # source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace = "dbp"
  stage     = ""
  name      = "api"

  cidr_block = "172.20.0.0/16"

}
