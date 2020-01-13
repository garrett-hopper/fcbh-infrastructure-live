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

  # administrative, to match cloudposse label
  namespace = "bibleis"
  name      = "web"
  stage     = "prod"
  
    # module-specific, sorted alphabetically

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
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

    # these environment variables are also set below. can this be removed?
    {
      namespace = "aws:cloudformation:template:parameter"
      name      = "EnvironmentVariables"
      value     = "npm_config_unsafe_perm=1,NODE_ENV=production,BASE_API_ROUTE=https://api.v4.dbt.io"
    },
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
# TODO: configure after discussion with Jon
    # {
    #   name      = "SSLCertificateArns"
    #   namespace = "aws:elbv2:listener:443"
    #   value     = "arn:aws:acm:us-west-2:509573027517:certificate/9c653674-b1de-4a7d-9483-87e1fd6962e0"
    # },    
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

  application_description = "bibleis Web Elastic Beanstalk Application"
  availability_zones      = ["us-west-2a", "us-west-2b"]
  dns_zone_id             = "" # "Z2ROOWAVSOOVLL"
  enable_stream_logs      = true
  env_vars = {
 # TODO: is this duplicating aws:cloudformation:template:parameter (lines 82-84)?     
    "BASE_API_ROUTE"         = "https://api.v4.dbt.io"
    "NODE_ENV"               = "production"
    "npm_config_unsafe_perm" = "1"
  }  
  environment_description = "bibleis Web Blue"
  #healthcheck_url = "/bible/ENGESV/MAT/1"  # uncomment when app is deployed
  instance_type           = "t3.small"
  loadbalancer_type       = "application"
  logs_retention_in_days  = 60
  nat_gateway_enabled     = true
  rolling_update_type     = "Health" # With Immutable, issues, maybe unrelated to Immutable
  solution_stack_name     = "64bit Amazon Linux 2018.03 v4.11.0 running Node.js"

}

# need to add
# add EC2 Termination Protection (probably in additionalSettings, namespace for launch configuration)
