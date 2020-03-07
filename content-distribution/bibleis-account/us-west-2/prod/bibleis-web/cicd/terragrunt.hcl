# member-account: bibleis

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//cicd"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "bibleis-beanstalk" {
  config_path = "../beanstalk"
}

inputs = {
  # namespace                          = "bibleis"
  # name                               = "cicd"
  # stage                              = ""  
  namespace = "sample"
  name      = "cicd"
  stage     = "dev"


  application_description            = "CICD resources for Bible.is web beanstalk"
  elastic_beanstalk_application_name = dependency.bibleis-beanstalk.outputs.elastic_beanstalk_application_name
  elastic_beanstalk_environment_name = dependency.bibleis-beanstalk.outputs.elastic_beanstalk_environment_name
  repo_owner                         = "bradflood"
  repo_name                          = "nodejs-simple"
  branch                             = "master"
}
