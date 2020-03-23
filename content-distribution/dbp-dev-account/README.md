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

### CICD extras

The dbp/cicd resources require permission to access the GitHub DBP repository. From the faithcomesbyhearing account, generate a personal access token according to the following instructions https://docs.aws.amazon.com/codepipeline/latest/userguide/GitHub-create-personal-token-CLI.html

Name the token appropriately so it is clear where it is being used. Suggestion: AWS CodePipeline in us-east-2

Create an environment variable suitably named so Terraform will process it as an input variable

```bash
export TF_VAR_github_oauth_token=<github token>
```

Furthermore, to deploy successfully, dbp/.ebextensions/env requires access to some special files.  Put in place via

```bash
aws --profile dbp-dev-admin s3 sync dbp/ s3://elasticbeanstalk-us-west-2-078432969830/dbp/
```

### Order of Creation

Create resources for each of the following modules:

1. vpc
2. bastion
3. route53
4. certificate/4.dbt.io
5. elasticache
6. rds
7. dbp/beanstalk
8. dbp/cicd (Note: see above CICD extras section for prerequisites)
