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

  peering_connection_id = "pcx-016d6004bb5295238"
  accepter_name_tag = "VPC peering connection with Analytics"
  requester_cidr_block = "172.19.0.0/16"
  accepter_subnet_id = "subnet-0514270361bd9075e" # dbp-dev private subnet in same AZ as the EC2 instance (us-west-2a)

  # requester_vpc_id = dependency.vpc.outputs.vpc_id
  # requester_cidr_block = dependency.vpc.outputs.cidr_block
  # requester_subnet_id = "subnet-07618ca39a2a80bed" # TODO could be derived from VPC resource
  # # requester_route_table_id = "23" #dependency.vpc.outputs.public_route_table_ids[0]


  # requester_name_tag = "VPC peering connection to DBP DEV"

  # accepter_owner_id = "078432969830" 
  # accepter_region = "us-west-2"
  # accepter_vpc_id = "vpc-0b6a6785e74d18db3" # TODO any way to clean this up? maybe not with STS:assumeRole
  # accepter_cidr_block = "172.17.0.0/16" 

  # accepter_profile = "dbp-dev" 
  # accepter_assume_role_arn = "arn:aws:iam::078432969830:role/AnalyticsCanAccessDbpDev" # this role in dbp-dev was created manually

  # accepter_intra_subnet_name = "subnet-007a9f5f2996ff70b" 

}
