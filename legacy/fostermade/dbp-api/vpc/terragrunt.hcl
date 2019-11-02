# Legacy dbp-web from Fostermade account

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../fcbh-infrastructure-modules//dbp/vpc"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace = "dbp"
  stage     = ""
  name      = "api"

  cidr_block = "172.20.0.0/16" # I think this is no longer referenced
  vpc_cidr_block = "172.20.0.0/16"

}


# Fostermade

#dbp-api
# terragrunt import module.vpc.aws_vpc.default  vpc-0ec0445c25bbc16d3
# terragrunt import module.vpc.aws_internet_gateway.default  igw-037be0e410d0293fc
# terragrunt import module.vpc.aws_default_security_group.default sg-01c0f8ec5a12e4b6f
# terragrunt import module.public_subnets.aws_nat_gateway.default[0] nat-0a52037ca5b3c6e0a
# terragrunt import module.public_subnets.aws_eip.default[0] eipalloc-00f09d084fa94bddf
# terragrunt import module.public_subnets.aws_network_acl.public[0] acl-05e967e4f26ec2a13

# terragrunt import module.public_subnets.aws_subnet.public[0] subnet-0aad0206a0a0bfa3e
# terragrunt import module.public_subnets.aws_subnet.public[1] subnet-034f62b7fa9703170
# terragrunt import module.private_subnets.aws_subnet.private[0] subnet-0a5fb79ce31dce45e
# terragrunt import module.private_subnets.aws_subnet.private[1] subnet-04fc74bfdfb95a21a


