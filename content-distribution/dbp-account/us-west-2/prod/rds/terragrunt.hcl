# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git//rds?ref=v0.1.7"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "temporary-dummy-id"
    private_subnet_ids = []
    vpc_default_security_group_id = ""
  }  
}
dependency "bastion" {
  config_path = "../bastion"
  mock_outputs = {
      security_group_id = ""
  }
}
# NOTE: this is not currently being used. The DBP RDS is in Fostermade
#
# aws_region: region in which organization resources will be created
# 
# aws_profile: refers to a named profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) 
# with sufficient permissions to create resources in the master account. 
#
#Before executing, create a snapshot in DBS and move it to DBP. Name the snapshot "pre-terraform-snapshot"
# to copy an RDS snapshot between accounts: https://aws.amazon.com/premiumsupport/knowledge-center/rds-snapshots-share-account/
#
# Note: db.r3.large or greater is needed to support Performance Insights
inputs = {
  namespace           = "dbp"
  stage               = ""
  name                = "rds"
  vpc_id              = dependency.vpc.outputs.vpc_id
  subnets             = dependency.vpc.outputs.private_subnet_ids
  security_groups     = [dependency.vpc.outputs.vpc_default_security_group_id, dependency.bastion.outputs.security_group_id]
  instance_type       = "db.r3.large"
  db_name             = "dbp_210117"
  snapshot_identifier = "pre-terraform-snapshot"
  autoscaling_enabled        = true
  autoscaling_target_metrics = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_value   = 70 # tied to instance_type. db.t3.small max connections is 90, so scale up before that target is hit
  autoscaling_min_capacity   = 2  # note: this compensates for a bug in the cloudposse module. In addition to read _replica count, add 1 for the writer. Reference: https://github.com/cloudposse/terraform-aws-rds-cluster/issues/63  
  deletion_protection = true
}