# splunk ec2 instances and related

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git//splunk?ref=v0.1.7"
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
dependency "bastion" {
  config_path = "../bastion"
}
dependency "route53" {
  config_path = "../route53"
}
dependency "certificate" {
  config_path = "../certificate"
}

inputs = {

  namespace = "analytics"
  stage     = ""
  name      = "splunk"
  
  vpc_id    = dependency.vpc.outputs.vpc_id
  availability_zones = dependency.vpc.outputs.availability_zones
  elb_subnets = dependency.vpc.outputs.public_subnet_ids
  splunk_subnet_id = dependency.vpc.outputs.private_subnet_ids[0]
  domain_name = "fcbh.org"
  ssh_pub_key_name = "analytics"
  bastion_security_group_id = dependency.bastion.outputs.security_group_id
  splunk_ami = "ami-0f7a62ef867109fe1"
  elb_access_cidr = ["140.82.163.2/32", "73.26.9.216/32", "45.58.38.254/32", "136.37.119.235/32", "73.242.135.160/32"]
  prod_search_head_instance_type = "c5.2xlarge"
  # indexer_instance_type = "c5.xlarge"
  forwarder_instance_type = "t3.medium"
  forwarder_iam_instance_profile = "Ec2SplunkInput"
  certificate_arn = dependency.certificate.outputs.arn
  route53_zone_id = dependency.route53.outputs.zone_id
  splunk_license_server_cidr = ["34.199.156.159/32"]
  peer_cidr_blocks = ["172.17.0.0/16", "172.20.0.0/16"]
}
