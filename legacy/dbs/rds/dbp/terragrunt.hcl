# Legacy RDS configuration 
# dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../fcbh-infrastructure-modules//dbp/data-storage"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace = "dbp"
  stage     = ""
  name      = "api"

  vpc_id = "vpc-64867f1c"
  subnets = ["subnet-8c7a0dc7"]

}


# DBS

#dbp-api
# terragrunt import module.rds_cluster_aurora_mysql.aws_rds_cluster.default dbp
#terragrunt import module.rds_cluster_aurora_mysql.aws_db_parameter_group.default[0] dbp-rds-custom
#terragrunt import  module.rds_cluster_aurora_mysql.aws_db_subnet_group.default[0] default
#terragrunt import module.rds_cluster_aurora_mysql.aws_rds_cluster_parameter_group.default[0] default.aurora5.6

#terragrunt import  module.rds_cluster_aurora_mysql.aws_rds_cluster_instance.default[0] dbp-t0
#terragrunt import module.rds_cluster_aurora_mysql.aws_rds_cluster_instance.default[1] dbp-t1


#??terragrunt import module.rds_cluster_aurora_mysql.aws_security_group.default[0] default
