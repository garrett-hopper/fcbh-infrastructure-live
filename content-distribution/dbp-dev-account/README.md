## General Instructions
For information on getting started, [start here](../../README.md)

## Instructions for managing DBP infrastructure

### Terraform state bucket: s3://fcbh-terraform-state-dbp-596282610570

### Starting directory: content-distribution/dbp-account-dev/us-west-2/fullstacklabs

### Basic instruction set

cd into each directory, then execute

```bash
terragrunt init
terragrunt plan
terragrunt apply (answer yes if the resources look correct)
```

### Route 53 extras

This process creates and populates the DNS zone dev.dbt.io.  After running terragrunt here, the below must also be done:
1. you must manually add an NS record to this zone in the parent domain dbt.io.  If this isn't done, the created certificates won't be verified.  
2. you must also manually add an A Alias record for dev.dbt.io to this subdomain dev.dbt.io that points at the the created beanstalk.dev.dbt.io.  If this isn't done, you can't successfully access the beanstalk via https.

### CICD extras

In order to successfully create the AWS CodePipeline, the dbp/cicd resources require permission to access the GitHub DBP repository. From the faithcomesbyhearing account, generate a personal access token according to the following instructions https://docs.aws.amazon.com/codepipeline/latest/userguide/GitHub-create-personal-token-CLI.html

Name the token appropriately so it is clear where it is being used. Suggestion: AWS CodePipeline in us-west-2

Create an environment variable suitably named so Terraform will process it as an input variable

```bash
export TF_VAR_github_oauth_token=<github token>
```

Now terragrunt can be run, which will use the token to setup the pipeline.

In addition, in order to successfully deploy the code, dbp/.ebextensions/env requires access to some secrets.  Put them in place via

```bash
aws --profile dbp-dev-admin s3 sync dbp/ s3://elasticbeanstalk-us-west-2-078432969830/dbp/
```

### RDS note

Please note that while the DBP_HOST and DBP_USERS_HOST in dbp/beanstalk/terragrunt.hcl can be set to the RDS cluster endpoints (and should be, in order to properly scale across additional instances and availability zones), in contrast, administrative access via sequelpro through the bastion must point at the instance endpoints in order to successfully connect (they won't work through the cluster endpoints).

### Order of Creation

Create resources for each of the following modules:

1. vpc
2. bastion
3. route53 (see Route 53 extras above)
4. certificate/4.dbt.io
5. elasticache
6. rds (see RDS note above)
7. dbp/beanstalk
8. dbp/cicd (see CICD extras above)
