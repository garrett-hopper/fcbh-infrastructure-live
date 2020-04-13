# fcbh-infrastructure-live

>This repository contains Terraform code to create AWS infrastructure for Faith Comes By Hearing (FCBH)

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

AWS Profiles are referenced in the code, but should not be set explicitly. We recommend that there be no default profile in ~/.aws/config

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

## Software Architecture

The terraform code to manage AWS resources is organized as a set of modules, managed in a separate GitHub repository [fcbh-infraastructure-modules](https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules).  This repository contains directories each of which contain a single terragrunt.hcl file. The terragrunt.hcl file references the modules and provides environment-specific information needed to create the AWS resource(s) exactly as intended for that environment. Separating the specifics of AWS resource wiring into separate modules allows the relationships between resources to be exactly the same between environments, without introducing the possibility of errors by duplicating the configuration for each environment.

Terragrunt provides a thin wrapper over the terraform modules to manage some of the more difficult challenges in managing infrastructure as code.  Instead of executing a terraform command, you will execute a terragrunt command instead.  This will assemble the code in a temporary directory, apply all common configuration, and then execute the corresponding terraform command. Any terraform command is valid from the terragrunt command line.

## Workflow

To create AWS resources using terraform, execute the following set of commands. Note that currently there is not a global command to create all AWS resources; instead, you must execute the following for each directory.

```bash
cd <directory containing terragrunt.hcl file>
terragrunt init
terragrunt plan
terragrunt apply (answer yes if the resources look correct)
```

## Infrastructure Components

Faith Comes By Hearing has the following infrastructure components, each of which has its own documentation

- Digital Bible Platform [(Production)](content-distribution/dbp-account/README.md)
[(Development)](content-distribution/dbp-dev-account/README.md)

- Bible.is mobile application [(Production)](content-distribution/bibleis-account/README.md)
[(Development)](content-distribution/bibleis-dev-account/README.md)