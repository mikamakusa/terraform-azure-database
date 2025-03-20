terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 3.1.0"
    }
  }
}