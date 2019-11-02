# Legacy Cloudfront configuration 

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../fcbh-infrastructure-modules//cloudfront"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace                = "dbp"
  stage                    = "prod"
  name                     = "cloudfront"
  parent_zone_id           = "Z2I9BDZUGOYIC2" #"Z3BJ6K6RIION7M"
  aliases                  = ["content.cdn.dbp-prod.dbp4.org"]
  log_prefix               = "cloudfront/dbp-prod/content.cdn.dbp-prod"
  acm_certificate_arn      = "arn:aws:acm:us-east-1:869054869504:certificate/4539f7c5-8446-4280-8c50-bda88bad4221"
  minimum_protocol_version = "TLSv1.1_2016"
  cors_allowed_origins     = ["*.fcbh.org", "content.cdn.dbp-prod.dbp4.org"]
}

#main distribution (ESTX6CKWMHOBF)
# terragrunt import module.cloudfront_s3_cdn.aws_cloudfront_distribution.default ESTX6CKWMHOBF
# terragrunt import module.cloudfront_s3_cdn.aws_cloudfront_origin_access_identity.default E2X79Y8LNMXOG8
# terragrunt import module.cloudfront_s3_cdn.aws_s3_bucket.origin[0] dbp-prod
#terragrunt import module.cloudfront_s3_cdn.module.logs.aws_s3_bucket.default[0] "dbp-log"

####module.cloudfront_s3_cdn.module.dns.aws_route53_record.default[0] 


/*
smooth streaming: true for video. Need to configure ordered_cache_behavior, which is not configurable with cloud_posse currently

target origin id: S3-dbp-prod
logging_config.bucket: dbp-log.s3.amazonaws.com
*/
