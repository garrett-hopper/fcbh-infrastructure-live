# fcbh-infrastructure-live

>Terraform code to create FCBH infrastructure

## Getting Started

- install terragrunt  https://terragrunt.gruntwork.io/docs/getting-started/install/ 
- install AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
- configure AWS profiles as needed https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
  - dbp-admin
  - bibleis-admin


## Introduction
While we use terraform for the resource creation, all terraform commands will be executed using the terragrunt wrapper.  This wrapper enables creation of AWS resources in multiple modules, with convenient linkage between the modules. 

Terraform state is stored in S3 buckets, with separate buckets for DBP and bibleis.  Resources can be created in more than one region, and for more than one stage (i.e. Prod or Dev). Within each bucket, the directory structure clearly identifies the region and stage for terraform state

The terragrunt/terraform commands are executed from a bash shell, in the directory containing a terragrunt.hcl file. This file references modules stored in a separate git repository, and provides configuration specific to the resources currently being created.

AWS Profiles are referenced in the code, but should not be set explicitely. We recommend that there be no default profile in ~/.aws/config



## Initial Setup Verification
For a complete example and to validate your local configuration, execute the following:
```bash
unset AWS_PROFILE
git clone https://github.com/faithcomesbyhearing/fcbh-infrastructure-live.git
cd fcbh-instrastructure-live
cd content-distribution/dbp-account/us-west-2/prod/vpc
terragrunt init
terragrunt plan
```

If everything is set up correctly, you should see something similar to the following:

```text

module.vpc.module.label.data.null_data_source.tags_as_list_of_maps[1]: Refreshing state...
module.vpc.module.label.data.null_data_source.tags_as_list_of_maps[0]: Refreshing state...
module.subnets.data.aws_availability_zones.available: Refreshing state...
data.aws_availability_zones.available: Refreshing state...

...

module.subnets.aws_route_table_association.private[1]: Refreshing state... [id=rtbassoc-xxx]
module.subnets.aws_route.default[2]: Refreshing state... [id=r-rtb-xxxx]
module.subnets.aws_route.default[1]: Refreshing state... [id=r-rtb-xxx]
module.subnets.aws_route.default[0]: Refreshing state... [id=r-rtb-xxx]

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```

## Instructions for managing DBP infrastructure

### Terraform state bucket: s3://fcbh-terraform-state-dbp-596282610570

### Starting directory: content-distribution/dbp-account/us-west-2/prod

### Basic instruction set

cd into each directory, then execute

```bash
terragrunt init
terragrunt plan
terragrunt apply (answer yes if the resources look correct)
```

### GitHub Access token for DBP

The dbp/cicd resources require permission to access the GitHub DBP repository. From the faithcomesbyhearing account, generate a personal access token according to the following instructions https://docs.aws.amazon.com/codepipeline/latest/userguide/GitHub-create-personal-token-CLI.html

Name the token appropriately so it is clear where it is being used. Suggestion: AWS CodePipeline in us-east-2

Create an environment variable suitably named so Terraform will process it as an input variable

```bash
export TF_VAR_github_oauth_token=<github token>
```

### Order of Creation

Create resources for each of the following modules:

1. vpc
2. bastion
3. route53
4. certificate / 4.dbt.io
5. elasticache
6. rds
7. dbp / beanstalk
8. dbp / cicd (Note: GitHub access token is required for this step)