# Organization: DBP
#      Organizational Unit: Operations
#           Member Account: Production

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//member-account"
}

# #Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
dependency "organizational-unit" {
  config_path = "../org-unit-operations"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  organizational_unit_id              = dependency.organizational-unit.outputs.organization_unit_id
  member_account_name                 = "DBP Production"
  member_account_email                = "bubcus@example.org"
  iam_users_accessing_member_account  = ["bwflood"]
  role_arn_referencing_member_account = { "dbp@prod" = "arn:aws:iam::627672411722:role/OrganizationAccountAccessRole" }
}