# member-account: dbp-dev

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git//data-storage/rds?ref=v0.1.6"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id                        = "temporary-dummy-id"
    private_subnet_ids            = []
    vpc_default_security_group_id = ""
  }
}
dependency "bastion" {
  config_path = "../../bastion"
  mock_outputs = {
    security_group_id = ""
  }
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
# Note: db.r3.large or greater is needed to support Performance Insights
# aurora mysql engine versions: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.11Updates.html
inputs = {
  namespace                  = "dbp"
  stage                      = "gideons"
  name                       = "api"
  vpc_id                     = dependency.vpc.outputs.vpc_id
  subnets                    = dependency.vpc.outputs.private_subnet_ids
  security_groups            = [dependency.vpc.outputs.vpc_default_security_group_id, dependency.bastion.outputs.security_group_id]
  instance_type              = "db.r3.large"
  engine_version             = "5.6.mysql_aurora.1.22.1"
  db_name                    = "dbp_gideons"
  snapshot_identifier        = "snapshot-2020-nov-24"
  autoscaling_enabled        = true
  autoscaling_target_metrics = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_value   = 700 # tied to instance_type. db.r5.large max connections is 1000, so scale up before that target is hit. https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Managing.Performance.html
  autoscaling_min_capacity   = 1  # note: this compensates for a bug in the cloudposse module. In addition to read _replica count, add 1 for the writer. Reference: https://github.com/cloudposse/terraform-aws-rds-cluster/issues/63
}
