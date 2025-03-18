module "keyvault" {
  source              = "./modules/terraform-azure-keyvault"
  resource_group_name = var.resource_group_name
  key_vault           = var.keyvault
  key_vault_key       = var.keyvault_key
}

module "storage" {
  source              = "./modules/terraform-azure-storage"
  resource_group_name = var.resource_group_name
  account             = var.storage_account
  container           = var.storage_container
}