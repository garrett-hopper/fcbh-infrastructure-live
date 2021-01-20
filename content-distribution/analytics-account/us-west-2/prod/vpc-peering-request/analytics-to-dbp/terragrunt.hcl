# member-account: analytics

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git//vpc-peering-request?ref=v0.1.6"
}

# Include all settings from the root terragrunt.hcl file
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
  requester_vpc_id = dependency.vpc.outputs.vpc_id
  requester_cidr_block = dependency.vpc.outputs.cidr_block
  requester_subnet_id = "subnet-07618ca39a2a80bed" # TODO could be derived from VPC resource
  
  requester_name_tag = "VPC peering connection to DBP"

  accepter_owner_id = "596282610570" 
  accepter_region = "us-west-2"
  accepter_vpc_id = "vpc-0720be0d173137a64" # TODO any way to clean this up? maybe not without STS:assumeRole
  accepter_cidr_block = "172.18.0.0/16" 

}

