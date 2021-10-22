terraform {

  backend "local" {}

  required_providers {
    aws    = ">= 3.0.0"
    random = ">= 2.1"
  }

  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-west-2"
}
