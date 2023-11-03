terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "azure_webapp_custom_domain_configuration_issue" {
  source    = "./modules/azure_webapp_custom_domain_configuration_issue"

  providers = {
    shoreline = shoreline
  }
}