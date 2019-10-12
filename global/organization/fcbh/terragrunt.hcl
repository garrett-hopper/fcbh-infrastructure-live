# Organization: FCBH

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//organization"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region                        = "us-east-2"
  aws_profile                       = "bibleis-admin"
  # tfstate_global_bucket             = "terragrunt-example-terraform-state-prod"
  # tfstate_global_bucket_region      = "us-east-1"
  namespace                         = "test-NAMESPACE"
  name                              = "test-NAME"
  # stage                             = "prod"
  # iam_users_accessing_prod          = ["bwflood"]
  # role_arn_referencing_prod_account = { "dbp@prod" = "arn:aws:iam::627672411722:role/OrganizationAccountAccessRole" }
}


# BWF org-id
# terragrunt import aws_organizations_organization.org o-x4ov8148vb
# FCBH org-id: o-6r809xjmit
#terragrunt import aws_organizations_organization.org o-6r809xjmit

