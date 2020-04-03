# member-account: dbp-dev

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../fcbh-infrastructure-modules//data-storage/rds"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}
dependency "bastion" {
  config_path = "../bastion"
}
#
# aws_region: region in which organization resources will be created
# 
# aws_profile: refers to a named profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) 
# with sufficient permissions to create resources in the master account. 
#
#Before executing, create a snapshot in DBS and move it to DBP. Name the snapshot "pre-terraform-snapshot"
# to copy an RDS snapshot between accounts: https://aws.amazon.com/premiumsupport/knowledge-center/rds-snapshots-share-account/
#
inputs = {
  namespace                  = "dbp"
  stage                      = "dev"
  name                       = "api"
  vpc_id                     = dependency.vpc.outputs.vpc_id
  subnets                    = dependency.vpc.outputs.private_subnet_ids
  security_groups            = [dependency.vpc.outputs.vpc_default_security_group_id, dependency.bastion.outputs.security_group_id]
  instance_type              = "db.t3.small"
  db_name                    = "dbp_dev"
  snapshot_identifier        = "dev-pre-terraform"
  autoscaling_enabled        = true
  autoscaling_target_metrics = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_value   = 70 # tied to instance_type. db.t3.small max connections is 90, so scale up before that target is hit
  autoscaling_min_capacity   = 2  # note: this compensates for a bug in the cloudposse module. In addition to read _replica count, add 1 for the writer. Reference: https://github.com/cloudposse/terraform-aws-rds-cluster/issues/63
}
