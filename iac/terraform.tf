terraform {
 backend "s3" {
 encrypt = true
 bucket = "nav-terraform-state"
 dynamodb_table = "tf-state-lock"
 region = "ap-south-1"
 key = "iac-test"
 }
}
