terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {}
provider "random" {}

variable "pspdfkit_api_key" {
  description = "API key for interacting with PSPDFKIT API."
  type        = string
}

resource "random_pet" "pspdfkit_api_key" {
  length    = 2
  separator = "-"
}

resource "aws_ssm_parameter" "pspdfkit_api_key" {
  name        = "/pspdfkit/${random_pet.pspdfkit_api_key.id}/api_key"
  description = "API Key for PSPDFKit API"
  type        = "SecureString"
  value       = var.pspdfkit_api_key
}

data "aws_region" "current" {}

output "PSPDFKIT_API_KEY" {
  value = {
    arn: aws_ssm_parameter.pspdfkit_api_key.arn
    key: aws_ssm_parameter.pspdfkit_api_key.name
    region: data.aws_region.current.name
    type: "ssm"
  }
}

output "PSPDFKIT_URL" {
  value = "https://api.pspdfkit.com/build"
}
