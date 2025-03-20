data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "this" {}

data "azurerm_subscription" "this" {}

data "azurerm_virtual_machine" "this" {
  count               = var.virtual_machine_name ? 1 : 0
  name                = var.virtual_machine_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_lb" "this" {
  count               = var.lb_name ? 1 : 0
  name                = var.lb_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_virtual_network" "this" {
  count               = var.virtual_network_name ? 1 : 0
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  count                = var.subnet_name ? 1 : 0
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.this.name
}

data "azuread_user" "this" {
  count               = var.azuread_user_name ? 1 : 0
  user_principal_name = var.azuread_user_name
}

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