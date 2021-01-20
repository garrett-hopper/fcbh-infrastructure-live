# dpb-api bastion host

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git//bastion?ref=v0.1.6"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id            = "temporary-dummy-id"
    bastion_subnet_id = "subnet-id"
  }
}

inputs = {

  namespace    = "dbp"
  stage        = "dev"
  name         = "api"
  instance_type = "t3.nano"  
  vpc_id       = dependency.vpc.outputs.vpc_id
  control_cidr = ["140.82.163.2/32", "34.215.119.74/32", "172.58.62.207/32", "73.98.86.246/32", "73.242.135.160/32", "75.150.17.102/32", "68.235.43.160/29", "136.37.119.235/32"]
  key_name     = "dbp-dev"
  subnet_id    = dependency.vpc.outputs.bastion_subnet_id
}
