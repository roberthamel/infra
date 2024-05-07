variable "minio_url" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = "k3d cluster create -c k3d-config.yaml"
  }
}

resource "null_resource" "cluster_delete" {
  provisioner "local-exec" {
    command = "k3d cluster delete -c k3d-config.yaml"
    when    = destroy
  }
}

terraform {
  backend "s3" {
    bucket = "rhms-terraform-state"
    key    = "k3d/terraform.tfstate"
    region = "us-east-1"
  }
}
