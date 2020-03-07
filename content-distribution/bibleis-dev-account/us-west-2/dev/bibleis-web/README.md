## General Instructions
For information on getting started, [start here](../../README.md)

## Instructions for managing bible.is DEV infrastructure

### Terraform state bucket: s3://fcbh-terraform-state-bibleis-dev-xx

### Starting directory: content-distribution/bibleis-dev-account/us-west-2/dev

### Basic instruction set

cd into each directory, then execute

```bash
terragrunt init
terragrunt plan
terragrunt apply (answer yes if the resources look correct)
```

<!-- ### GitHub Access token for bibleis

The bibleis/cicd resources require permission to access the CodeCommit bibleis repository. From the faithcomesbyhearing account, generate a personal access token according to the following instructions https://docs.aws.amazon.com/codepipeline/latest/userguide/GitHub-create-personal-token-CLI.html

Name the token appropriately so it is clear where it is being used. Suggestion: AWS CodePipeline in us-east-2

Create an environment variable suitably named so Terraform will process it as an input variable

```bash
export TF_VAR_github_oauth_token=<github token> -->
```

### Order of Creation

Create resources for each of the following modules:

1. vpc
2. bastion
3. route53
4. certificate
5. bibleis / beanstalk
6. bibleis / cicd