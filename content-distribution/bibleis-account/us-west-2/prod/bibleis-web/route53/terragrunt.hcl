# member-account: bibleis

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//route53"
  #source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace = "bibleis"
  stage     = ""
  name      = "web"
  zone_name = "bible.is" 
}
