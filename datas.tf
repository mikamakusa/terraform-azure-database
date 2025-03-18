data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "this" {}

data "azurerm_user_assigned_identity" "this" {
  name                = var.user_assigned_identity_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_key_vault" "this" {
  count               = var.keyvault_name ? 1 : 0
  name                = var.keyvault_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_key_vault_key" "this" {
  count        = var.keyvault_key_name ? 1 : 0
  key_vault_id = data.azurerm_key_vault.this.id
  name         = var.keyvault_key_name
}

data "azurerm_storage_account" "this" {
  count               = var.storage_account_name ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_storage_container" "this" {
  count = var.storage_container_name ? 1 : 0
  name  = var.storage_container_name
}