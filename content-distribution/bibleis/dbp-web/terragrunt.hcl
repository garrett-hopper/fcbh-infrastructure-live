# bibleis dbp-web

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace               = "bibleis"
  stage                   = "prod"
  name                    = "web"
  # environment             = "blue"  
  # application_name        = "appname"
  application_description = "DBP Elastic Beanstalk Application"

  environment_description = "DBP Web Blue"

  availability_zones         = ["us-west-2a", "us-west-2b"] 
  availability_zone_selector = "Any 2"
  dns_zone_id                = "" # "Z2ROOWAVSOOVLL"
  instance_type              = "t3.small"
  wait_for_ready_timeout     = "20m"

  environment_type = "LoadBalanced"

  loadbalancer_type = "application"
  elb_scheme        = "public"
  tier              = "WebServer"
  version_label     = ""
  force_destroy     = true
  root_volume_size  = 8
  root_volume_type  = "gp2"

  autoscale_min             = 2
  autoscale_max             = 3
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

  solution_stack_name = "64bit Amazon Linux 2018.03 v4.11.0 running Node.js"

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
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "EC2KeyName"
      value     = "reader-web-stage"
    },
    {
      name      = "ImageId"
      namespace = "aws:autoscaling:launchconfiguration"
      value     = "ami-025b9e7fb09f871fe"
    },    
    {
      namespace = "aws:cloudformation:template:parameter"
      name      = "EnvironmentVariables"
      value     = "npm_config_unsafe_perm=1,NODE_ENV=production,BASE_API_ROUTE=https://api.v4.dbt.io"
    },
    {
      name      = "NodeCommand"
      namespace = "aws:elasticbeanstalk:container:nodejs"
      value     = "./node_modules/.bin/cross-env NODE_ENV=production node nextServer"
    }, 
    {
      name      = "NodeVersion"
      namespace = "aws:elasticbeanstalk:container:nodejs"
      value     = "10.15.1"
    },
    {
      name      = "SSLCertificateArns"
      namespace = "aws:elbv2:listener:443"
      value     = "arn:aws:acm:us-west-2:509573027517:certificate/9c653674-b1de-4a7d-9483-87e1fd6962e0"
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

  env_vars = {
    "BASE_API_ROUTE"  = "https://api.v4.dbt.io"
    "NODE_ENV"        = "production"

    # "API_URL"         = "https://api.v4.dbt.io"
    # "APP_DEBUG"       = "0"
    # "APP_ENV"         = "production"
    # "APP_URL"         = "https://v4.dbt.io"
    # "APP_URL_PODCAST" = "https://v4.dbt.io"
  }
}

