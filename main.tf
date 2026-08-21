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

# resource "azurerm_resource_group" "rg" {
#   name     = "rg-techsmart-dev"
#   location = "West US 2"
# }

# Storage Account criado manualmente - não gerenciado por Terraform
# satechsmartdev001 - ADLS Gen2 com HNS habilitado
# Containers para as camadas Medallion
resource "azurerm_storage_container" "landing" {
  name                  = "landing"
  storage_account_name  = "satechsmartdev001"
  container_access_type = "private"
}

resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = "satechsmartdev001"
  container_access_type = "private"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = "satechsmartdev001"
  container_access_type = "private"
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_name  = "satechsmartdev001"
  container_access_type = "private"
}

resource "azurerm_storage_container" "slogs" {
  name                  = "slogs"
  storage_account_name  = "satechsmartdev001"
  container_access_type = "private"
}