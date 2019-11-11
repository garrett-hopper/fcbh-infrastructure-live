# content-distribution / bibleis

remote_state {
  backend = "s3"
  config = {
    bucket = "bibleis-terraform-state"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

inputs = {
  aws_region  = "us-west-2"
  aws_profile = "bibleis-admin"
}