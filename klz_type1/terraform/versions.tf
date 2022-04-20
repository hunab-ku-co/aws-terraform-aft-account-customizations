terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.10.0"
    }
        local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.2"
    }
    utils = {
      source  = "cloudposse/utils"
      version = "0.17.15"
    }
  }
}
