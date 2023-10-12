# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "lakewater-co.tfstate"
    key       = "lakewater-co"
    region    = "us-east-1"
    profile   = "terraform-user"
  }
}