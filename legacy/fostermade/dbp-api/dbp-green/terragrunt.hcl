# Legacy dbp-api (dbp-green) from Fostermade account

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../fcbh-infrastructure-modules//dbp/elastic-beanstalk"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace               = "dbp"
  stage                   = ""
  name                    = "api"
  application_name        = "api"
  application_description = "DBP Elastic Beanstalk Application"
  environment_name        = "green"
  environment_description = "DBP API (Green, prod I think)"

  availability_zones         = ["us-west-2a", "us-west-2b"]
  availability_zone_selector = "Any 2"
  dns_zone_id                = "" # "Z2ROOWAVSOOVLL"
  instance_type              = "t3.micro"
  wait_for_ready_timeout     = "20m"

  environment_type = "SingleInstance"

  loadbalancer_type = "application"
  elb_scheme        = "public"
  tier              = "WebServer"
  version_label     = ""
  force_destroy     = true
  root_volume_size  = 8
  root_volume_type  = "gp2"

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

  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.0 running PHP 7.3"

  vpc_id = vpc-0ec0445c25bbc16d3

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
  additional_settings = [
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "StickinessEnabled"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions"
      name      = "ManagedActionsEnabled"
      value     = "false"
    }


  ]

  env_vars = {
    "DB_HOST"         = "xxxxxxxxxxxxxx"
    "DB_USERNAME"     = "yyyyyyyyyyyyy"
    "DB_PASSWORD"     = "zzzzzzzzzzzzzzzzzzz"
    "ANOTHER_ENV_VAR" = "123456789"
    "API_URL"         = "https://api.v4.dbt.io"
    "APP_DEBUG"       = "0"
    "APP_ENV"         = "production"
    "APP_URL"         = "https://v4.dbt.io"
    "APP_URL_PODCAST" = "https://v4.dbt.io"
  }
}


# Fostermade
#dbp-api
#terragrunt import module.elastic_beanstalk_application.aws_elastic_beanstalk_application.default dbp-api
#terragrunt import module.elastic_beanstalk_environment.aws_elastic_beanstalk_environment.default e-7wxzmqmmhx

#module.elastic_beanstalk_environment.aws_security_group.default  sg-00ffe041d860136c9

