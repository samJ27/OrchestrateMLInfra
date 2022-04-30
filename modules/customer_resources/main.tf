data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
    name = "${var.customer_name}-customer-rg"
    location = var.location
}

resource "azurerm_key_vault" "kv" {
    name = "${var.customer_name}-kv"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku_name = "standard"
    tenant_id = azurerm_client_config.current.tenant_id
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.customer_name}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_application_insights" "ai" {
  name                = "${var.customer_name}-mlworkspace-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_storage_account" "strg" {
  name                     = "${var.customer_name}wsstrg"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "example-workspace"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  application_insights_id = azurerm_application_insights.ai.id
  key_vault_id            = azurerm_key_vault.kv.id
  storage_account_id      = azurerm_storage_account.strg.id
  
  identity {
    type = "SystemAssigned"
  }
}