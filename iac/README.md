# Launch Instance

This terraform configuration launches an AWS instance in region ap-south-1 & availability zone 1a, with 20 GB OS volume & 100 GB local data volume.
It also maintains the state of this setup the S3 bucket & creates a lock in the DynamoDB if an operation/change is in progress on this setup.

## Requirements

 - You need to install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html#installing-terraform) v0.12.3 on the machine where you want to test this.
 - You also need to add [environment variables](https://www.terraform.io/docs/providers/aws/index.html#environment-variables) for AWS credentials on the machine from where you will execute this.
