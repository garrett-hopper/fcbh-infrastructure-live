# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
}
dependency "bastion" {
  config_path = "../../bastion"
}
dependency "rds" {
  config_path = "../../rds"
}
dependency "elasticache" {
  config_path = "../../elasticache"
}
dependency "route53" {
  config_path = "../../route53"
}
dependency "certificate" {
  config_path = "../../certificate/dbt.io"
}
# to copy an RDS snapshot between accounts: https://aws.amazon.com/premiumsupport/knowledge-center/rds-snapshots-share-account/
inputs = {
  namespace = "dbp"
  stage     = ""
  name      = "beanstalk"

  application_description    = "dbp"
  vpc_id                     = dependency.vpc.outputs.vpc_id
  public_subnets             = dependency.vpc.outputs.public_subnet_ids
  private_subnets            = dependency.vpc.outputs.private_subnet_ids
  allowed_security_groups    = [dependency.bastion.outputs.security_group_id, dependency.vpc.outputs.vpc_default_security_group_id]
  additional_security_groups = [dependency.bastion.outputs.security_group_id]
  keypair                    = "dbp"

  description                  = "DBP Elastic Beanstalk "
  dns_zone_id                  = dependency.route53.outputs.zone_id
  loadbalancer_certificate_arn = dependency.certificate.outputs.arn
  instance_type                = "t3.small" # change to t3.medium when closer to production date

  environment_description = "DBP Production environment"

  healthcheck_url    = "/"
  enable_stream_logs = true

  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.2 running PHP 7.2"

  env_vars = {
    "APP_ENV"            = "prod"
    "APP_URL"            = "https://4.dbt.io"
    "API_URL"            = "https://4.dbt.io/api"
    "APP_URL_PODCAST"    = "https://4.dbt.io"
    "APP_DEBUG"          = "0"
    "DBP_HOST"           = dependency.rds.outputs.reader_endpoint
    "DBP_USERNAME"       = "api_node_dbp"
    "DBP_USERS_HOST"     = dependency.rds.outputs.endpoint
    "DBP_USERS_DATABASE" = "dbp_users"
    "DBP_USERS_USERNAME" = "api_node_dbp"
    "MEMCACHE_HOST"      = dependency.elasticache.outputs.cluster_configuration_endpoint
  }
}
