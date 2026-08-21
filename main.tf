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

data "azurerm_client_config" "current" {}

# ============================================================================
# CONTAINERS - CAMADAS MEDALLION
# ============================================================================

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

# ============================================================================
# KEY VAULT - MODO RBAC
# ============================================================================

resource "azurerm_key_vault" "kv" {
  name                        = "kvtechsmart001"
  location                    = "West US 2"
  resource_group_name         = "rg-techsmart-dev"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = false
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope              = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id       = data.azurerm_client_config.current.object_id
}

# ============================================================================
# DATABRICKS WORKSPACE - PREMIUM TIER
# ============================================================================

resource "azurerm_databricks_workspace" "workspace" {
  name                = "dbw-techsmart-dev"
  resource_group_name = "rg-techsmart-dev"
  location            = "West US 2"
  sku                 = "premium"

  tags = {
    Environment = "dev"
    Project     = "TechSmart"
  }
}

# ============================================================================
# OUTPUTS
# ============================================================================

output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "storage_containers" {
  value = {
    landing = azurerm_storage_container.landing.id
    bronze  = azurerm_storage_container.bronze.id
    silver  = azurerm_storage_container.silver.id
    gold    = azurerm_storage_container.gold.id
    slogs   = azurerm_storage_container.slogs.id
  }
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.workspace.workspace_url
}