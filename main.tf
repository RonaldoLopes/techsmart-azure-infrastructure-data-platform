terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-techsmart-dev"
  location = "West US 2"
}

# Storage Account criado manualmente - não gerenciado por Terraform
# satechsmartdev001 - ADLS Gen2 com HNS habilitado