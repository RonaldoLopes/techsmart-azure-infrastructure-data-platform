terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

variable "prefixo" {
  description = "Prefixo usado no nome de todos os recursos"
  type        = string
  default     = "techsmart"
}

variable "regiao" {
  description = "Regiao do Azure"
  type        = string
  default     = "westus2"
}
# 1) Resource Group: a caixa que agrupa tudo
resource "azurerm_resource_group" "rg" {
  name = "rg-${var.prefixo}-dev"
  location = var.regiao
  tags = {
    projeto  = var.prefixo
    ambiente = "dev"
    dono     = "engenharia-de-dados"
  }
}
resource "azurerm_storage_account" "storage" {
  name                     = "st${replace(var.prefixo, "-", "")}${substr(random_id.workspace.hex, 0, 4)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  tags = {
    projeto      = var.prefixo
    ambiente     = "dev"
    centro_custo = "eng-dados"
  }
}

resource "random_id" "workspace" {
  byte_length = 4
}
# 2) Workspace Databricks
resource "azurerm_databricks_workspace" "dbw" {
  name                = "dbw-${var.prefixo}-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku = "premium"
  tags = {
    projeto  = var.prefixo
    ambiente = "dev"
  }
}
output "workspace_url"{
  description = "Abra este endereco no navegador"
  value       = "https://${azurerm_databricks_workspace.dbw.workspace_url}"
}
# 3) Controle de custo desde o primeiro dia
resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "budget-${var.prefixo}-dev"
  resource_group_id = azurerm_resource_group.rg.id
  amount            = 50
  time_grain        = "Monthly"

  time_period {
    start_date = "2026-08-01T00:00:00Z"
    end_date   = "2027-08-01T00:00:00Z"
  }

  notification {
    enabled       = true
    threshold     = 80
    operator      = "GreaterThan"
    contact_emails = ["ronaldorclopes@gmail.com"]
  }

  notification {
    enabled       = true
    threshold     = 100
    operator      = "GreaterThan"
    contact_emails = ["ronaldorclopes@gmail.com"]
  }
}

resource "azurerm_data_factory" "adf" {
  name = "adf-${var.prefixo}-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  identity {
    type = "SystemAssigned"
  }
  tags = {
    projeto = var.prefixo
    ambiente = "dev"
  }
}
output "data_factory_name" {
  value = azurerm_data_factory.adf.name
}

resource "azurerm_role_assignment" "adf_databricks_contributor" {
  scope                = azurerm_databricks_workspace.dbw.id
  role_definition_name = "Contributor"
  principal_id         = "760a38e7-c9d0-4b3a-92ca-9f85172ae4b5"  # ID correto do ADF
}
resource "azurerm_role_assignment" "adf_storage_blob_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id          = "760a38e7-c9d0-4b3a-92ca-9f85172ae4b5"
}
#kafka
resource "azurerm_eventhub_namespace" "ehns" {
  name                = "ehns-${var.prefixo}-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard" # Standard e o minimo para Kafka
  capacity            = 1
}
resource "azurerm_eventhub" "estoque" {
  name                = "eh-estoque"
  namespace_name      = azurerm_eventhub_namespace.ehns.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 4
  message_retention   = 7
}
resource "azurerm_eventhub_authorization_rule" "app" {
  name = "app-techsmart"
  namespace_name      = azurerm_eventhub_namespace.ehns.name
  eventhub_name       = azurerm_eventhub.estoque.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = true
  manage              = false
}
output "eventhub_connection_string" {
  value     = azurerm_eventhub_authorization_rule.app.primary_connection_string
  sensitive = true
}
#openai
# TODO: Uncomment after quota access is approved
# resource "azurerm_cognitive_account" "openai" {
#   name                = "oai-${var.prefixo}-dev"
#   resource_group_name = azurerm_resource_group.rg.name
#   location = azurerm_resource_group.rg.location
#   kind = "OpenAI"
#   sku_name = "S0"
#
#   tags = { projeto = var.prefixo, ambiente = "dev" }
# }
#
# resource "azurerm_cognitive_deployment" "gpt" {
#   name                 = "gpt-4o-mini"
#   cognitive_account_id = azurerm_cognitive_account.openai.id
#
#   model {
#     format  = "OpenAI"
#     name    = "gpt-4o-mini"
#     version = "2024-07-18"
#   }
#
#   scale {
#     type     = "Standard"
#     capacity = 10 # milhares de tokens por minuto
#   }
# }
