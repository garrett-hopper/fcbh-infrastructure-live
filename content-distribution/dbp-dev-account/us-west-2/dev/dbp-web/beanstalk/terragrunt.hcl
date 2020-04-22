# member-account: dbp-dev

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git//elastic-beanstalk?ref=v0.1.2"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id = "temporary-dummy-id"
    public_subnet_ids = []
    private_subnet_ids = []
    vpc_default_security_group_id = ""
  }  
}
dependency "bastion" {
  config_path = "../../bastion"
  mock_outputs = {
      security_group_id = "sg-id"
  }  
}
dependency "route53" {
  config_path = "../../route53"
  mock_outputs = {
      zone_id = ""
  }    
}
dependency "certificate" {
  config_path = "../../certificate/dev.dbt.io"
  mock_outputs = {
      arn = ""
  }    
}

inputs = {
  namespace = "dbp"
  stage     = "dev"
  name      = "web"

  application_description    = "DBP Web"
  vpc_id                     = dependency.vpc.outputs.vpc_id
  public_subnets             = dependency.vpc.outputs.public_subnet_ids
  private_subnets            = dependency.vpc.outputs.private_subnet_ids
  allowed_security_groups    = [dependency.bastion.outputs.security_group_id, dependency.vpc.outputs.vpc_default_security_group_id]
  additional_security_groups = [dependency.bastion.outputs.security_group_id]
  keypair                    = "dbp-dev"

  description                  = "DBP Web Elastic Beanstalk"
  dns_zone_id                  = dependency.route53.outputs.zone_id
  loadbalancer_certificate_arn = dependency.certificate.outputs.arn
  instance_type                = "t3.small"

  environment_description = "DBP Web Development environment"
  version_label           = ""
  force_destroy           = true
  root_volume_size        = 8
  root_volume_type        = "gp2"

  autoscale_min             = 1
  autoscale_max             = 2
  autoscale_measure_name    = "CPUUtilization"
  autoscale_statistic       = "Average"
  autoscale_unit            = "Percent"
  autoscale_lower_bound     = 20
  autoscale_lower_increment = -1
  autoscale_upper_bound     = 80
  autoscale_upper_increment = 1

  rolling_update_enabled  = true
  rolling_update_type     = "Health"
  updating_min_in_service = 0
  updating_max_batch      = 1

  healthcheck_url  = "/"
  application_port = 80

  solution_stack_name = "64bit Amazon Linux 2018.03 v4.13.1 running Node.js"

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
  additional_settings = [

  ]

  env_vars = {
    "APP_ENV"         = "dev"
    "APP_URL"         = "https://dev.dbt.io"
    "API_URL"         = "https://dev.dbt.io/api"
    "APP_URL_PODCAST" = "https://dev.dbt.io"
    "APP_DEBUG"       = "1"
  }
}
