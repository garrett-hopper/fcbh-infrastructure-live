# bibleis dbp-web

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
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

  # administrative, to match cloudposse label
  namespace = "bibleis"
  name      = "web"
  stage     = "prod"

  vpc_id                     = dependency.vpc.outputs.vpc_id
  public_subnets             = dependency.vpc.outputs.public_subnet_ids
  private_subnets            = dependency.vpc.outputs.private_subnet_ids
  allowed_security_groups    = [dependency.bastion.outputs.security_group_id, dependency.vpc.outputs.vpc_default_security_group_id]
  additional_security_groups = [dependency.bastion.outputs.security_group_id]
  keypair                    = "bibleis-dev"

  description                  = "Bibleis Web"
  dns_zone_id                  = dependency.route53.outputs.zone_id
  loadbalancer_certificate_arn = dependency.certificate.outputs.arn
  instance_type                = "t3.small"
  loadbalancer_type            = "application"


  application_description = "bible.is Web Elastic Beanstalk Application"
  environment_description = "bible.is Web Production environment"
  version_label           = ""
  force_destroy           = true
  root_volume_size        = 8
  root_volume_type        = "gp2"

  autoscale_min             = 2
  autoscale_max             = 3
  autoscale_measure_name    = "CPUUtilization"
  autoscale_statistic       = "Average"
  autoscale_unit            = "Percent"
  autoscale_lower_bound     = 20
  autoscale_lower_increment = -1
  autoscale_upper_bound     = 80
  autoscale_upper_increment = 1

  rolling_update_enabled = true
  rolling_update_type    = "Health"

  updating_min_in_service = 0
  updating_max_batch      = 1

  healthcheck_url        = "/"
  application_port       = 80
  logs_retention_in_days = 60

  solution_stack_name = "64bit Amazon Linux 2018.03 v4.11.0 running Node.js"
  # upgrade candidate: 64bit Amazon Linux 2018.03 v4.13.0 running Node.js 

  env_vars = {
    "BASE_API_ROUTE"         = "https://4.dbt.io/api"
    "NODE_ENV"               = "production"
    "npm_config_unsafe_perm" = "1"
  }


  // https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
  ###### put as much of this as possible in .ebextensions, it's related to eb environment, not the durable configuration
  additional_settings = [
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "StickinessEnabled"
      value     = "false"
    },


    # is a keypair needed if we enable SSM Session Manager? or is there another reason the keypair is needed
    # {
    #   namespace = "aws:autoscaling:launchconfiguration"
    #   name      = "EC2KeyName"
    #   value     = "reader-web-stage"
    # },


    # uncomment when bibleis node app is deployed
    # {
    #   name      = "NodeCommand"
    #   namespace = "aws:elasticbeanstalk:container:nodejs"
    #   value     = "./node_modules/.bin/cross-env NODE_ENV=production node nextServer"
    # },
    {
      name      = "NodeVersion"
      namespace = "aws:elasticbeanstalk:container:nodejs"
      value     = "10.15.1"
    },
    {
      name      = "AppSource"
      namespace = "aws:cloudformation:template:parameter"
      value     = "http://s3-us-west-2.amazonaws.com/elasticbeanstalk-samples-us-west-2/nodejs-sample-v2.zip"
    },
    {
      name      = "Automatically Terminate Unhealthy Instances"
      namespace = "aws:elasticbeanstalk:monitoring"
      value     = "true"
    },
    {
      name      = "XRayEnabled"
      namespace = "aws:elasticbeanstalk:xray"
      value     = "true"
    }

  ]



}

