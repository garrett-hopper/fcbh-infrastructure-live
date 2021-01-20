# member-account: dbp-dev

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git//vpc-peering-accept?ref=v0.1.6"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id            = "temporary-dummy-id"
    bastion_subnet_id = "subnet-id"
  }
}
// EC2 instances reside in us-west-2a

inputs = {
  namespace = "analytics"
  stage     = "prod"
  name      = "vpc-peering"

  peering_connection_id = "pcx-0369d2ed2b0bcfc62"
  accepter_name_tag = "VPC peering connection with Analytics"
  requester_cidr_block = "172.19.0.0/16"
  accepter_subnet_id = "subnet-03350bfd970a16ba1" # dbp private subnet in same AZ as the EC2 instance (us-west-2a)

}
