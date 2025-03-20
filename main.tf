resource "azurerm_mssql_database" "this" {
  count                       = length(var.mssql_server) == 0 ? 0 : length(var.mssql_database)
  name                        = lookup(var.mssql_database[count.index], "name")
  server_id                   = element(azurerm_mssql_server.this.*.id, lookup(var.mssql_database[count.index], "server_id"))
  auto_pause_delay_in_minutes = lookup(var.mssql_database[count.index], "auto_pause_delay_in_minutes")
  create_mode                 = lookup(var.mssql_database[count.index], "create_mode")
  /*creation_source_database_id                                = ""*/
  collation                      = lookup(var.mssql_database[count.index], "collation")
  elastic_pool_id                = try(element(azurerm_mssql_elasticpool.this.*.id, lookup(var.mssql_database[count.index], "elastic_pool_id")))
  enclave_type                   = lookup(var.mssql_database[count.index], "enclave_type")
  geo_backup_enabled             = lookup(var.mssql_database[count.index], "geo_backup_enabled")
  maintenance_configuration_name = lookup(var.mssql_database[count.index], "maintenance_configuration_name")
  ledger_enabled                 = lookup(var.mssql_database[count.index], "ledger_enabled")
  license_type                   = lookup(var.mssql_database[count.index], "license_type")
  max_size_gb                    = lookup(var.mssql_database[count.index], "max_size_gb")
  min_capacity                   = lookup(var.mssql_database[count.index], "min_capacity")
  restore_point_in_time          = lookup(var.mssql_database[count.index], "restore_point_in_time")
  /*recovery_point_id                                          = ""
  recover_database_id                                        = ""
  restore_dropped_database_id                                = ""
  restore_long_term_retention_backup_id                      = ""*/
  read_replica_count                                         = lookup(var.mssql_database[count.index], "read_replica_count")
  read_scale                                                 = lookup(var.mssql_database[count.index], "read_scale")
  sample_name                                                = lookup(var.mssql_database[count.index], "sample_name")
  sku_name                                                   = lookup(var.mssql_database[count.index], "sku_name")
  storage_account_type                                       = lookup(var.mssql_database[count.index], "storage_account_type")
  transparent_data_encryption_enabled                        = lookup(var.mssql_database[count.index], "transparent_data_encryption_enabled")
  transparent_data_encryption_key_automatic_rotation_enabled = lookup(var.mssql_database[count.index], "transparent_data_encryption_key_automatic_rotation_enabled")
  transparent_data_encryption_key_vault_key_id               = try(var.keyvault_key_name ? data.azurerm_key_vault_key.this.id : element(module.keyvault.*.key_vault_key_id, lookup(var.mssql_database[count.index], "transparent_data_encryption_key_vault_key_id")))
  zone_redundant                                             = lookup(var.mssql_database[count.index], "zone_redundant")
  secondary_type                                             = lookup(var.mssql_database[count.index], "secondary_type")
  tags                                                       = lookup(var.mssql_database[count.index], "tags")

  identity {
    identity_ids = [data.azurerm_user_assigned_identity.this.id]
    type         = "UserAssigned"
  }

  dynamic "import" {
    for_each = try(lookup(var.mssql_database[count.index], "import") == null ? [] : ["import"])
    content {
      administrator_login          = sensitive(lookup(import.value, "administrator_login"))
      administrator_login_password = sensitive(lookup(import.value, "administrator_login_password"))
      authentication_type          = lookup(import.value, "authentication_type")
      storage_key                  = lookup(import.value, "storage_key")
      storage_key_type             = lookup(import.value, "storage_key_type")
      storage_uri                  = lookup(import.value, "storage_uri")
      storage_account_id           = ""
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = try(lookup(var.mssql_database[count.index], "long_term_retention_policy") == null ? [] : ["long_term_retention_policy"])
    content {
      weekly_retention          = lookup(long_term_retention_policy.value, "weekly_retention")
      monthly_retention         = lookup(long_term_retention_policy.value, "monthly_retention")
      yearly_retention          = lookup(long_term_retention_policy.value, "yearly_retention")
      week_of_year              = lookup(long_term_retention_policy.value, "week_of_year")
      immutable_backups_enabled = lookup(long_term_retention_policy.value, "immutable_backups_enabled")
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = try(lookup(var.mssql_database[count.index], "short_term_retention_policy") == null ? [] : ["short_term_retention_policy"])
    content {
      retention_days           = lookup(short_term_retention_policy.value, "retention_days")
      backup_interval_in_hours = lookup(short_term_retention_policy.value, "backup_interval_in_hours")
    }
  }

  dynamic "threat_detection_policy" {
    for_each = try(lookup(var.mssql_database[count.index], "threat_detection_policy") == null ? [] : ["threat_detection_policy"])
    content {
      state                      = lookup(threat_detection_policy.value, "state")
      disabled_alerts            = lookup(threat_detection_policy.value, "disabled_alerts")
      email_account_admins       = lookup(threat_detection_policy.value, "email_account_admins")
      email_addresses            = lookup(threat_detection_policy.value, "email_addresses")
      retention_days             = lookup(threat_detection_policy.value, "retention_days")
      storage_account_access_key = lookup(threat_detection_policy.value, "storage_account_access_key")
      storage_endpoint           = lookup(threat_detection_policy.value, "storage_endpoint")
    }
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "this" {
  count                                   = length(var.mssql_database) == 0 ? 0 : length(var.mssql_database_extended_auditing_policy)
  database_id                             = element(azurerm_mssql_database.this.*.id, lookup(var.mssql_database_extended_auditing_policy[count.index], "database_id"))
  storage_endpoint                        = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(var.mssql_database_extended_auditing_policy[count.index], "storage_id")))
  retention_in_days                       = lookup(var.mssql_database_extended_auditing_policy[count.index], "retention_in_days")
  storage_account_access_key              = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(var.mssql_database_extended_auditing_policy[count.index], "storage_id")))
  storage_account_access_key_is_secondary = lookup(var.mssql_database_extended_auditing_policy[count.index], "storage_account_access_key_is_secondary")
  log_monitoring_enabled                  = lookup(var.mssql_database_extended_auditing_policy[count.index], "log_monitoring_enabled")
}

resource "azurerm_mssql_database_vulnerability_assessment_rule_baseline" "this" {
  count                              = (length(var.mssql_database) && length(var.mssql_server_vulnerability_assessment)) == 0 ? 0 : length(var.mssql_database_vulnerability_assessment_rule_baseline)
  database_name                      = element(azurerm_mssql_database.this.*.name, lookup(var.mssql_database_vulnerability_assessment_rule_baseline[count.index], "database_id"))
  rule_id                            = lookup(var.mssql_database_vulnerability_assessment_rule_baseline[count.index], "rule_id")
  server_vulnerability_assessment_id = element(azurerm_mssql_server_vulnerability_assessment.this.*.id, lookup(var.mssql_database_vulnerability_assessment_rule_baseline[count.index], "server_vulnerability_assessment_id"))
  baseline_name                      = lookup(var.mssql_database_vulnerability_assessment_rule_baseline[count.index], "baseline_name")

  dynamic "baseline_result" {
    for_each = try(lookup(var.mssql_database_vulnerability_assessment_rule_baseline[count.index], "baseline_result") == null ? [] : ["baseline_result"])
    content {
      result = lookup(baseline_result.value, "result")
    }
  }
}

resource "azurerm_mssql_elasticpool" "this" {
  count                          = length(var.mssql_server) == 0 ? 0 : length(var.mssql_elasticpool)
  location                       = data.azurerm_resource_group.this.location
  name                           = lookup(var.mssql_elasticpool[count.index], "name")
  resource_group_name            = data.azurerm_resource_group.this.name
  server_name                    = element(azurerm_mssql_server.this.*.name, lookup(var.mssql_elasticpool[count.index], "server_id"))
  maintenance_configuration_name = lookup(var.mssql_elasticpool[count.index], "maintenance_configuration_name")
  max_size_bytes                 = lookup(var.mssql_elasticpool[count.index], "max_size_bytes")
  max_size_gb                    = lookup(var.mssql_elasticpool[count.index], "max_size_gb")
  enclave_type                   = lookup(var.mssql_elasticpool[count.index], "enclave_type")
  tags                           = lookup(var.mssql_elasticpool[count.index], "tags")
  zone_redundant                 = lookup(var.mssql_elasticpool[count.index], "zone_redundant")
  license_type                   = lookup(var.mssql_elasticpool[count.index], "license_type")

  dynamic "per_database_settings" {
    for_each = try(lookup(var.mssql_elasticpool[count.index], "per_database_settings") == null ? [] : ["per_database_settings"])
    content {
      max_capacity = lookup(per_database_settings.value, "max_capacity")
      min_capacity = lookup(per_database_settings.value, "min_capacity")
    }
  }

  dynamic "sku" {
    for_each = try(lookup(var.mssql_elasticpool[count.index], "sku") == null ? [] : ["sku"])
    content {
      capacity = lookup(sku.value, "capacity")
      name     = lookup(sku.value, "name")
      tier     = lookup(sku.value, "tier")
      family   = lookup(sku.value, "family")
    }
  }
}

resource "azurerm_mssql_failover_group" "this" {
  count                                     = length(var.mssql_server) == 0 ? 0 : length(var.mssql_failover_group)
  name                                      = lookup(var.mssql_failover_group[count.index], "name")
  server_id                                 = element(azurerm_mssql_server.this.*.id, lookup(var.mssql_failover_group[count.index], "server_id"))
  databases                                 = lookup(var.mssql_failover_group[count.index], "databases")
  readonly_endpoint_failover_policy_enabled = lookup(var.mssql_failover_group[count.index], "readonly_endpoint_failover_policy_enabled")
  tags                                      = lookup(var.mssql_failover_group[count.index], "tags")

  dynamic "partner_server" {
    for_each = try(lookup(var.mssql_failover_group[count.index], "partner_server") == null ? [] : ["partner_server"])
    content {
      id = element(azurerm_mssql_server.this.*.id, lookup(partner_server.value, "id"))
    }
  }

  dynamic "read_write_endpoint_failover_policy" {
    for_each = try(lookup(var.mssql_failover_group[count.index], "read_write_endpoint_failover_policy") == null ? [] : ["read_write_endpoint_failover_policy"])
    content {
      mode          = lookup(read_write_endpoint_failover_policy.value, "mode")
      grace_minutes = lookup(read_write_endpoint_failover_policy.value, "grace_minutes")
    }
  }
}

resource "azurerm_mssql_firewall_rule" "this" {
  count            = length(var.mssql_server) == 0 ? 0 : length(var.mssql_firewall_rule)
  end_ip_address   = lookup(var.mssql_firewall_rule[count.index], "end_ip_address")
  name             = lookup(var.mssql_firewall_rule[count.index], "name")
  server_id        = element(azurerm_mssql_server.this.*.id, lookup(var.mssql_firewall_rule[count.index], "server_id"))
  start_ip_address = lookup(var.mssql_firewall_rule[count.index], "start_ip_address")
}

resource "azurerm_mssql_job_agent" "this" {
  count       = length(var.mssql_database) == 0 ? 0 : length(var.mssql_job_agent)
  database_id = element(azurerm_mssql_database.this.*.id, lookup(var.mssql_job_agent[count.index], "database_id"))
  location    = data.azurerm_resource_group.this.location
  name        = lookup(var.mssql_job_agent[count.index], "name")
  tags        = lookup(var.mssql_job_agent[count.index], "tags")
}

resource "azurerm_mssql_job_credential" "this" {
  count        = length(var.mssql_job_agent) == 0 ? 0 : length(var.mssql_job_credential)
  job_agent_id = element(azurerm_mssql_job_agent.this.*.id, lookup(var.mssql_job_agent[count.index], "job_agent_id"))
  name         = lookup(var.mssql_job_credential[count.index], "name")
  password     = lookup(var.mssql_job_credential[count.index], "password")
  username     = lookup(var.mssql_job_credential[count.index], "username")
}

resource "azurerm_mssql_managed_database" "this" {
  count                     = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_database)
  managed_instance_id       = element(azurerm_mssql_managed_instance.this.*.id, lookup(var.mssql_managed_database[count.index], "managed_instance_id"))
  name                      = lookup(var.mssql_managed_database[count.index], "name")
  short_term_retention_days = lookup(var.mssql_managed_database[count.index], "short_term_retention_days")


  dynamic "long_term_retention_policy" {
    for_each = try(lookup(var.mssql_managed_database[count.index], "long_term_retention_policy") == null ? [] : ["long_term_retention_policy"])
    content {
      weekly_retention  = lookup(long_term_retention_policy.value, "weekly_retention")
      monthly_retention = lookup(long_term_retention_policy.value, "monthly_retention")
      yearly_retention  = lookup(long_term_retention_policy.value, "yearly_retention")
      week_of_year      = lookup(long_term_retention_policy.value, "week_of_year")
    }
  }

  dynamic "point_in_time_restore" {
    for_each = try(lookup(var.mssql_managed_database[count.index], "point_in_time_restore") == null ? [] : ["point_in_time_restore"])
    content {
      restore_point_in_time = lookup(point_in_time_restore.value, "restore_point_in_time")
      source_database_id    = try(element(azurerm_mssql_database.this.*.id, lookup(point_in_time_restore.value, "source_database_id")))
    }
  }
}

resource "azurerm_mssql_managed_instance" "this" {
  count                        = length(var.mssql_managed_instance)
  administrator_login          = sensitive(lookup(var.mssql_managed_instance[count.index], "administrator_login"))
  administrator_login_password = sensitive(lookup(var.mssql_managed_instance[count.index], "administrator_login_password"))
  license_type                 = lookup(var.mssql_managed_instance[count.index], "license_type")
  location                     = data.azurerm_resource_group.this.name
  name                         = lookup(var.mssql_managed_instance[count.index], "name")
  resource_group_name          = data.azurerm_resource_group.this.location
  sku_name                     = lookup(var.mssql_managed_instance[count.index], "sku_name")
  storage_size_in_gb           = lookup(var.mssql_managed_instance[count.index], "storage_size_in_gb")
  subnet_id                    = data.azurerm_subnet.this.id
  vcores                       = lookup(var.mssql_managed_instance[count.index], "vcores")
}

resource "azurerm_mssql_managed_instance_active_directory_administrator" "this" {
  count               = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_active_directory_administrator)
  login_username      = lookup(var.mssql_managed_instance_active_directory_administrator[count.index], "login_username")
  managed_instance_id = element(azurerm_mssql_managed_instance.this.*.id, lookup(var.mssql_managed_instance_active_directory_administrator[count.index], "managed_instance_id"))
  object_id           = data.azuread_user.this.object_id
  tenant_id           = data.azurerm_client_config.this.tenant_id
}

resource "azurerm_mssql_managed_instance_failover_group" "this" {
  count                                     = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_failover_group)
  location                                  = data.azurerm_resource_group.this.name
  managed_instance_id                       = element(azurerm_mssql_managed_instance.this.*.id, lookup(var.mssql_managed_instance_failover_group[count.index], "managed_instance_id"))
  name                                      = lookup(var.mssql_managed_instance_failover_group[count.index], "name")
  partner_managed_instance_id               = element(azurerm_mssql_managed_instance.this.*.id, lookup(var.mssql_managed_instance_failover_group[count.index], "partner_managed_instance_id"))
  readonly_endpoint_failover_policy_enabled = lookup(var.mssql_managed_instance_failover_group[count.index], "readonly_endpoint_failover_policy_enabled")
  secondary_type                            = lookup(var.mssql_managed_instance_failover_group[count.index], "secondary_type")

  dynamic "read_write_endpoint_failover_policy" {
    for_each = try(lookup(var.mssql_managed_instance_failover_group[count.index], "read_write_endpoint_failover_policy") == null ? [] : ["read_write_endpoint_failover_policy"])
    content {
      mode          = lookup(read_write_endpoint_failover_policy.value, "mode")
      grace_minutes = lookup(read_write_endpoint_failover_policy.value, "grace_minutes")
    }
  }
}

resource "azurerm_mssql_managed_instance_security_alert_policy" "this" {
  count                        = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_security_alert_policy)
  managed_instance_name        = element(azurerm_mssql_managed_instance.this.*.name, lookup(var.mssql_managed_instance_security_alert_policy[count.index], "managed_instance_id"))
  resource_group_name          = data.azurerm_resource_group.this.name
  disabled_alerts              = lookup(var.mssql_managed_instance_security_alert_policy[count.index], "disabled_alerts")
  enabled                      = lookup(var.mssql_managed_instance_security_alert_policy[count.index], "enabled")
  email_account_admins_enabled = lookup(var.mssql_managed_instance_security_alert_policy[count.index], "email_account_admins_enabled")
  email_addresses              = lookup(var.mssql_managed_instance_security_alert_policy[count.index], "email_addresses")
  retention_days               = lookup(var.mssql_managed_instance_security_alert_policy[count.index], "retention_days")
  storage_endpoint             = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(var.mssql_managed_instance_security_alert_policy[count.index], "storage_account_id")))
  storage_account_access_key   = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(var.mssql_managed_instance_security_alert_policy[count.index], "storage_account_id")))
}

resource "azurerm_mssql_managed_instance_transparent_data_encryption" "this" {
  count                 = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_transparent_data_encryption)
  managed_instance_id   = element(azurerm_mssql_managed_instance.this.*.name, lookup(var.mssql_managed_instance_transparent_data_encryption[count.index], "managed_instance_id"))
  key_vault_key_id      = try(var.keyvault_key_name ? data.azurerm_key_vault_key.this.id : element(module.keyvault.*.key_vault_key_id, lookup(var.mssql_managed_instance_transparent_data_encryption[count.index], "key_vault_key_id")))
  auto_rotation_enabled = true
}

resource "azurerm_mssql_managed_instance_vulnerability_assessment" "this" {
  count               = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_vulnerability_assessment)
  managed_instance_id = element(azurerm_mssql_managed_instance.this.*.name, lookup(var.mssql_managed_instance_vulnerability_assessment[count.index], "managed_instance_id"))
  storage_container_path = join("", [
    var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(var.mssql_managed_instance_vulnerability_assessment[count.index], "storage_account_id")),
    var.storage_container_name ? data.azurerm_storage_container.this.name : element(module.storage.*.container_name, lookup(var.mssql_managed_instance_vulnerability_assessment[count.index], "storage_container_id"))
  ])
  storage_account_access_key = var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(var.mssql_managed_instance_vulnerability_assessment[count.index], "storage_account_id"))

  dynamic "recurring_scans" {
    for_each = try(lookup(var.mssql_managed_instance_vulnerability_assessment[count.index], "recurring_scans") == null ? [] : ["recurring_scans"])
    content {
      enabled                   = lookup(recurring_scans.value, "enabled")
      email_subscription_admins = lookup(recurring_scans.value, "email_subscription_admins")
      emails                    = lookup(recurring_scans.value, "emails")
    }
  }
}

resource "azurerm_mssql_outbound_firewall_rule" "this" {
  count     = length(var.mssql_server) == 0 ? 0 : length(var.mssql_outbound_firewall_rule)
  name      = lookup(var.mssql_outbound_firewall_rule[count.index], "name")
  server_id = element(azurerm_mssql_server.this.*.id, lookup(var.mssql_outbound_firewall_rule[count.index], "server_id"))
}

resource "azurerm_mssql_server" "this" {
  count                                        = length(var.mssql_server)
  location                                     = data.azurerm_resource_group.this.location
  name                                         = lookup(var.mssql_server[count.index], "name")
  resource_group_name                          = data.azurerm_resource_group.this.name
  version                                      = lookup(var.mssql_server[count.index], "version")
  administrator_login                          = sensitive(lookup(var.mssql_server[count.index], "administrator_login"))
  administrator_login_password                 = sensitive(lookup(var.mssql_server[count.index], "administrator_login_password"))
  connection_policy                            = lookup(var.mssql_server[count.index], "connection_policy")
  transparent_data_encryption_key_vault_key_id = try(var.keyvault_key_name ? data.azurerm_key_vault_key.this.id : element(module.keyvault.*.key_vault_key_id, lookup(var.mssql_server[count.index], "")))
  minimum_tls_version                          = lookup(var.mssql_server[count.index], "minimum_tls_version")
  public_network_access_enabled                = lookup(var.mssql_server[count.index], "public_network_access_enabled")
  outbound_network_restriction_enabled         = lookup(var.mssql_server[count.index], "outbound_network_restriction_enabled")
  primary_user_assigned_identity_id            = ""
  tags                                         = lookup(var.mssql_server[count.index], "tags")

  dynamic "azuread_administrator" {
    for_each = try(lookup(var.mssql_server[count.index], "azuread_administrator") == null ? [] : ["azuread_administrator"])
    content {
      login_username              = lookup(azuread_administrator.value, "login_username")
      object_id                   = data.azurerm_user_assigned_identity.this.name
      tenant_id                   = data.azurerm_user_assigned_identity.this.principal_id
      azuread_authentication_only = lookup(azuread_administrator.value, "azuread_authentication_only")
    }
  }

  dynamic "identity" {
    for_each = try(lookup(var.mssql_server[count.index], "identity") == null ? [] : ["identity"])
    content {
      type         = lookup(identity.value, "type")
      identity_ids = [lookup(identity.value, "type") == "SystemAssigned" ? data.azurerm_user_assigned_identity.this.id : null]
    }
  }
}

resource "azurerm_mssql_server_dns_alias" "this" {
  count           = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_dns_alias)
  mssql_server_id = element(azurerm_mssql_server.this.*.id, lookup(var.mssql_server_dns_alias[count.index], "mssql_server_id"))
  name            = lookup(var.mssql_server_dns_alias[count.index], "name")
}

resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  count                                   = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_extended_auditing_policy)
  server_id                               = element(azurerm_mssql_server.this.*.id, lookup(var.mssql_database_extended_auditing_policy[count.index], "server_id"))
  enabled                                 = lookup(var.mssql_database_extended_auditing_policy[count.index], "enabled")
  storage_endpoint                        = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(var.mssql_database_extended_auditing_policy[count.index], "storage_account_id")))
  retention_in_days                       = lookup(var.mssql_database_extended_auditing_policy[count.index], "retention_in_days")
  storage_account_access_key              = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(var.mssql_database_extended_auditing_policy[count.index], "storage_account_id")))
  storage_account_access_key_is_secondary = lookup(var.mssql_database_extended_auditing_policy[count.index], "storage_account_access_key_is_secondary")
  log_monitoring_enabled                  = lookup(var.mssql_database_extended_auditing_policy[count.index], "log_monitoring_enabled")
  storage_account_subscription_id         = data.azurerm_subscription.this.subscription_id
  predicate_expression                    = lookup(var.mssql_database_extended_auditing_policy[count.index], "predicate_expression")
  audit_actions_and_groups                = lookup(var.mssql_database_extended_auditing_policy[count.index], "audit_actions_and_groups")
}

resource "azurerm_mssql_server_microsoft_support_auditing_policy" "this" {
  count                           = length(var.mssql_server) == 0 ? 0 : length(var.support_auditing_policy)
  server_id                       = element(azurerm_mssql_server.this.*.id, lookup(var.support_auditing_policy[count.index], "server_id"))
  enabled                         = lookup(var.support_auditing_policy[count.index], "enabled")
  blob_storage_endpoint           = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(var.support_auditing_policy[count.index], "storage_account_id")))
  storage_account_access_key      = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(var.support_auditing_policy[count.index], "storage_account_id")))
  storage_account_subscription_id = data.azurerm_subscription.this.subscription_id
  log_monitoring_enabled          = lookup(var.support_auditing_policy[count.index], "log_monitoring_enabled")
}

resource "azurerm_mssql_server_security_alert_policy" "this" {
  count                      = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_security_alert_policy)
  resource_group_name        = data.azurerm_resource_group.this.name
  server_name                = element(azurerm_mssql_server.this.*.name, lookup(var.mssql_server_security_alert_policy[count.index], "server_id"))
  state                      = lookup(var.mssql_server_security_alert_policy[count.index], "state")
  disabled_alerts            = lookup(var.mssql_server_security_alert_policy[count.index], "disabled_alerts")
  email_account_admins       = lookup(var.mssql_server_security_alert_policy[count.index], "email_account_admins")
  email_addresses            = lookup(var.mssql_server_security_alert_policy[count.index], "email_addresses")
  retention_days             = lookup(var.mssql_server_security_alert_policy[count.index], "retention_days")
  storage_endpoint           = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(var.mssql_server_security_alert_policy[count.index], "storage_account_id")))
  storage_account_access_key = try(var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(var.mssql_server_security_alert_policy[count.index], "storage_account_id")))
}

resource "azurerm_mssql_server_transparent_data_encryption" "this" {
  count                 = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_transparent_data_encryption)
  server_id             = element(azurerm_mssql_server.this.*.name, lookup(var.mssql_server_transparent_data_encryption[count.index], "server_id"))
  key_vault_key_id      = try(var.keyvault_key_name ? data.azurerm_key_vault_key.this.id : element(module.keyvault.*.key_vault_key_id, lookup(var.mssql_server_transparent_data_encryption[count.index], "key_vault_key_id")))
  auto_rotation_enabled = true
}

resource "azurerm_mssql_server_vulnerability_assessment" "this" {
  count                           = length(var.mssql_server_security_alert_policy) == 0 ? 0 : length(var.mssql_server_vulnerability_assessment)
  server_security_alert_policy_id = element(azurerm_mssql_server_security_alert_policy.this.*.id, lookup(var.mssql_server_vulnerability_assessment[count.index], "server_security_alert_policy_id"))
  storage_container_path = join("", [
    var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(var.mssql_server_vulnerability_assessment[count.index], "storage_account_id")),
    var.storage_container_name ? data.azurerm_storage_container.this.name : element(module.storage.*.container_name, lookup(var.mssql_server_vulnerability_assessment[count.index], "storage_container_id"))
  ])
  storage_account_access_key = var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(var.mssql_server_vulnerability_assessment[count.index], "storage_account_id"))

  dynamic "recurring_scans" {
    for_each = try(lookup(var.mssql_server_vulnerability_assessment[count.index], "recurring_scans") == null ? [] : ["recurring_scans"])
    content {
      enabled                   = lookup(recurring_scans.value, "enabled")
      email_subscription_admins = lookup(recurring_scans.value, "email_subscription_admins")
      emails                    = lookup(recurring_scans.value, "emails")
    }
  }
}

resource "azurerm_mssql_virtual_machine" "this" {
  count                            = length(var.mssql_virtual_machine)
  virtual_machine_id               = data.azurerm_virtual_machine.this.id
  sql_license_type                 = lookup(var.mssql_virtual_machine[count.index], "sql_license_type")
  r_services_enabled               = lookup(var.mssql_virtual_machine[count.index], "r_services_enabled")
  sql_connectivity_port            = lookup(var.mssql_virtual_machine[count.index], "sql_connectivity_port")
  sql_connectivity_type            = lookup(var.mssql_virtual_machine[count.index], "sql_connectivity_type")
  sql_connectivity_update_password = sensitive(lookup(var.mssql_virtual_machine[count.index], "sql_connectivity_update_password"))
  sql_connectivity_update_username = sensitive(lookup(var.mssql_virtual_machine[count.index], "sql_connectivity_update_username"))
  tags                             = lookup(var.mssql_virtual_machine[count.index], "tags", )

  dynamic "auto_backup" {
    for_each = try(lookup(var.mssql_virtual_machine[count.index], "auto_backup") == null ? [] : ["auto_backup"])
    content {
      retention_period_in_days   = lookup(auto_backup.value, "retention_period_in_days")
      storage_account_access_key = var.storage_account_name ? data.azurerm_storage_account.this.primary_access_key : element(module.storage.*.storage_account_primary_access_key, lookup(auto_backup.value, "storage_account_id"))
      storage_blob_endpoint      = var.storage_account_name ? data.azurerm_storage_account.this.primary_blob_endpoint : element(module.storage.*.storage_account_primary_blob_endpoint, lookup(auto_backup.value, "storage_account_id"))
      encryption_enabled         = lookup(auto_backup.value, "encryption_enabled")
      encryption_password        = sensitive(lookup(auto_backup.value, "encryption_password"))

      dynamic "manual_schedule" {
        for_each = try(lookup(auto_backup.value, "manual_schedule") == null ? [] : ["manual_schedule"])
        content {
          full_backup_frequency           = lookup(manual_schedule.value, "full_backup_frequency")
          full_backup_start_hour          = lookup(manual_schedule.value, "full_backup_start_hour")
          full_backup_window_in_hours     = lookup(manual_schedule.value, "full_backup_window_in_hours")
          log_backup_frequency_in_minutes = lookup(manual_schedule.value, "log_backup_frequency_in_minutes")
          days_of_week                    = lookup(manual_schedule.value, "days_of_week")
        }
      }
    }
  }

  dynamic "auto_patching" {
    for_each = try(lookup(var.mssql_virtual_machine[count.index], "auto_patching") == null ? [] : ["auto_patching"])
    content {
      day_of_week                            = lookup(auto_patching.value, "day_of_week")
      maintenance_window_duration_in_minutes = lookup(auto_patching.value, "maintenance_window_duration_in_minutes")
      maintenance_window_starting_hour       = lookup(auto_patching.value, "maintenance_window_starting_hour")
    }
  }

  dynamic "key_vault_credential" {
    for_each = try(lookup(var.mssql_virtual_machine[count.index], "key_vault_credential") == null ? [] : ["key_vault_credential"])
    content {
      key_vault_url            = lookup(key_vault_credential.value, "key_vault_url")
      name                     = lookup(key_vault_credential.value, "name")
      service_principal_name   = lookup(key_vault_credential.value, "service_principal_name")
      service_principal_secret = lookup(key_vault_credential.value, "service_principal_secret")
    }
  }

  dynamic "sql_instance" {
    for_each = try(lookup(var.mssql_virtual_machine[count.index], "sql_instance") == null ? [] : ["sql_instance"])
    content {
      adhoc_workloads_optimization_enabled = lookup(sql_instance.value, "adhoc_workloads_optimization_enabled")
      collation                            = lookup(sql_instance.value, "collation")
      instant_file_initialization_enabled  = lookup(sql_instance.value, "instant_file_initialization_enabled")
      lock_pages_in_memory_enabled         = lookup(sql_instance.value, "lock_pages_in_memory_enabled")
      max_dop                              = lookup(sql_instance.value, "max_dop")
      max_server_memory_mb                 = lookup(sql_instance.value, "max_server_memory_mb")
      min_server_memory_mb                 = lookup(sql_instance.value, "min_server_memory_mb")
    }
  }

  dynamic "storage_configuration" {
    for_each = try(lookup(var.mssql_virtual_machine[count.index], "storage_configuration") == null ? [] : ["storage_configuration"])
    content {
      disk_type             = lookup(storage_configuration.value, "disk_type")
      storage_workload_type = lookup(storage_configuration.value, "storage_workload_type")
    }
  }

  dynamic "wsfc_domain_credential" {
    for_each = try(lookup(var.mssql_virtual_machine[count.index], "wsfc_domain_credential") == null ? [] : ["wsfc_domain_credential"])
    content {
      cluster_bootstrap_account_password = sensitive(lookup(wsfc_domain_credential.value, "cluster_bootstrap_account_password"))
      cluster_operator_account_password  = sensitive(lookup(wsfc_domain_credential.value, "cluster_operator_account_password"))
      sql_service_account_password       = sensitive(lookup(wsfc_domain_credential.value, "sql_service_account_password"))
    }
  }
}

resource "azurerm_mssql_virtual_machine_availability_group_listener" "this" {
  count                        = length(var.mssql_virtual_machine_group) == 0 ? 0 : length(var.mssql_virtual_machine_availability_group_listener)
  name                         = lookup(azurerm_mssql_virtual_machine_availability_group_listener[count.index], "name")
  sql_virtual_machine_group_id = element(azurerm_mssql_virtual_machine_group.this.*.id, lookup(var.mssql_virtual_machine_availability_group_listener[count.index], "sql_virtual_machine_group_id"))
  availability_group_name      = lookup(azurerm_mssql_virtual_machine_availability_group_listener[count.index], "availability_group_name")
  port                         = lookup(azurerm_mssql_virtual_machine_availability_group_listener[count.index], "port")

  dynamic "load_balancer_configuration" {
    for_each = try(lookup(var.mssql_virtual_machine_availability_group_listener[count.index], "load_balancer_configuration") == null ? [] : ["load_balancer_configuration"])
    content {
      load_balancer_id        = data.azurerm_lb.this.id
      private_ip_address      = lookup(load_balancer_configuration.value, "private_ip_address")
      probe_port              = lookup(load_balancer_configuration.value, "probe_port")
      sql_virtual_machine_ids = [element(azurerm_mssql_virtual_machine.this.*.id, lookup(load_balancer_configuration.value, "sql_virtual_machine_ids"))]
      subnet_id               = data.azurerm_subnet.this.id
    }
  }

  dynamic "multi_subnet_ip_configuration" {
    for_each = try(lookup(var.mssql_virtual_machine_availability_group_listener[count.index], "multi_subnet_ip_configuration") == null ? [] : ["multi_subnet_ip_configuration"])
    content {
      private_ip_address     = lookup(multi_subnet_ip_configuration.value, "private_ip_address")
      sql_virtual_machine_id = element(azurerm_mssql_virtual_machine.this.*.id, lookup(multi_subnet_ip_configuration.value, "sql_virtual_machine_ids"))
      subnet_id              = data.azurerm_subnet.this.id
    }
  }

  dynamic "replica" {
    for_each = try(lookup(var.mssql_virtual_machine_availability_group_listener[count.index], "replica") == null ? [] : ["replica"])
    content {
      commit                 = lookup(replica.value, "commit")
      failover_mode          = lookup(replica.value, "failover_mode")
      readable_secondary     = lookup(replica.value, "readable_secondary")
      role                   = lookup(replica.value, "role")
      sql_virtual_machine_id = element(azurerm_mssql_virtual_machine.this.*.id, lookup(replica.value, "sql_virtual_machine_ids"))
    }
  }
}

resource "azurerm_mssql_virtual_machine_group" "this" {
  count               = length(var.mssql_virtual_machine_group)
  location            = data.azurerm_resource_group.this.location
  name                = lookup(var.mssql_virtual_machine_group[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
  sql_image_offer     = lookup(var.mssql_virtual_machine_group[count.index], "sql_image_offer")
  sql_image_sku       = lookup(var.mssql_virtual_machine_group[count.index], "sql_image_sku")
  tags                = lookup(var.mssql_virtual_machine_group[count.index], "tags")
}

resource "azurerm_mssql_virtual_network_rule" "this" {
  count                                = length(var.mssql_server) == 0 ? 0 : length(var.mssql_virtual_network_rule)
  name                                 = lookup(var.mssql_virtual_network_rule[count.index], "name")
  server_id                            = element(azurerm_mssql_server.this.*.id, lookup(var.mssql_virtual_network_rule[count.index], "server_id"))
  subnet_id                            = data.azurerm_subnet.this.id
  ignore_missing_vnet_service_endpoint = lookup(var.mssql_virtual_network_rule[count.index], "ignore_missing_vnet_service_endpoint")
}

resource "azurerm_mysql_flexible_database" "this" {
  count               = length(var.mysql_flexible_server) == 0 ? 0 : length(var.mysql_flexible_database)
  charset             = lookup(var.mysql_flexible_database[count.index], "charset")
  collation           = lookup(var.mysql_flexible_database[count.index], "collation")
  name                = lookup(var.mysql_flexible_database[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_mysql_flexible_server.this.*.name, lookup(var.mysql_flexible_database[count.index], "server_id"))
}

resource "azurerm_mysql_flexible_server" "this" {
  count                             = length(var.mysql_flexible_server)
  location                          = data.azurerm_resource_group.this.location
  name                              = lookup(var.mysql_flexible_server[count.index], "name")
  resource_group_name               = data.azurerm_resource_group.this.name
  administrator_login               = sensitive(lookup(var.mysql_flexible_server[count.index], "administrator_login"))
  administrator_password            = sensitive(lookup(var, ))
  backup_retention_days             = lookup(var.mysql_flexible_server[count.index], "administrator_password")
  create_mode                       = lookup(var.mysql_flexible_server[count.index], "backup_retention_days")
  delegated_subnet_id               = lookup(var.mysql_flexible_server[count.index], "create_mode")
  geo_redundant_backup_enabled      = lookup(var.mysql_flexible_server[count.index], "delegated_subnet_id")
  point_in_time_restore_time_in_utc = lookup(var.mysql_flexible_server[count.index], "geo_redundant_backup_enabled")
  private_dns_zone_id               = lookup(var.mysql_flexible_server[count.index], "point_in_time_restore_time_in_utc")
  replication_role                  = lookup(var.mysql_flexible_server[count.index], "private_dns_zone_id")
  sku_name                          = lookup(var.mysql_flexible_server[count.index], "replication_role")
  source_server_id                  = lookup(var.mysql_flexible_server[count.index], "sku_name")
  version                           = lookup(var.mysql_flexible_server[count.index], "source_server_id")
  zone                              = lookup(var.mysql_flexible_server[count.index], "version")
  tags                              = lookup(var.mysql_flexible_server[count.index], "zone")

  dynamic "customer_managed_key" {
    for_each = try(lookup(var.mysql_flexible_server[count.index], "customer_managed_key") == null ? [] : ["customer_managed_key"])
    content {
      key_vault_key_id = element(module.keyvault.*.key_vault_key_id, lookup(customer_managed_key.value, "key_vault_key_id"))
    }
  }

  dynamic "high_availability" {
    for_each = try(lookup(var.mysql_flexible_server[count.index], "high_availability") == null ? [] : ["high_availability"])
    content {
      mode                      = lookup(high_availability.value, "mode")
      standby_availability_zone = lookup(high_availability.value, "standby_availability_zone")
    }
  }

  dynamic "identity" {
    for_each = try(lookup(var.mysql_flexible_server[count.index], "identity") == null ? [] : ["identity"])
    content {
      identity_ids = lookup(identity.value, "identity_ids")
      type         = "UserAssigned"
    }
  }

  dynamic "maintenance_window" {
    for_each = try(lookup(var.mysql_flexible_server[count.index], "maintenance_window") == null ? [] : ["maintenance_window"])
    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week")
      start_hour   = lookup(maintenance_window.value, "start_hour")
      start_minute = lookup(maintenance_window.value, "start_minute")
    }
  }

  dynamic "storage" {
    for_each = try(lookup(var.mysql_flexible_server[count.index], "storage") == null ? [] : ["storage"])
    content {
      auto_grow_enabled  = lookup(storage.value, "auto_grow_enabled")
      io_scaling_enabled = lookup(storage.value, "io_scaling_enabled")
      iops               = lookup(storage.value, "iops")
      size_gb            = lookup(storage.value, "size_gb")
    }
  }
}

resource "azurerm_mysql_flexible_server_active_directory_administrator" "this" {
  count       = length(var.mysql_flexible_server) == 0 ? 0 : length(var.mysql_flexible_server_active_directory_administrator)
  identity_id = data.azurerm_client_config.this.id
  login       = sensitive(lookup(var.mysql_flexible_server_active_directory_administrator[count.index], "login"))
  object_id   = data.azurerm_client_config.this.object_id
  server_id   = element(azurerm_mysql_flexible_server.this.*.id, lookup(var.mysql_flexible_server_active_directory_administrator[count.index], "server_id"))
  tenant_id   = data.azurerm_client_config.this.tenant_id
}

resource "azurerm_mysql_flexible_server_configuration" "this" {
  count               = length(var.mysql_flexible_server) == 0 ? 0 : length(var.mysql_flexible_server_configuration)
  name                = lookup(var.mysql_flexible_server_configuration[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_mysql_flexible_server.this.*.name, lookup(var.mysql_flexible_server_configuration[count.index], "server_id"))
  value               = lookup(var.mysql_flexible_server_configuration[count.index], "value")
}

resource "azurerm_mysql_flexible_server_firewall_rule" "this" {
  count               = length(var.mysql_flexible_server) == 0 ? 0 : length(var.mysql_flexible_server_firewall_rule)
  end_ip_address      = lookup(var.mysql_flexible_server_firewall_rule[count.index], "end_ip_address")
  name                = lookup(var.mysql_flexible_server_firewall_rule[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_mysql_flexible_server.this.*.name, lookup(var.mysql_flexible_server_firewall_rule[count.index], "server_id"))
  start_ip_address    = lookup(var.mysql_flexible_server_firewall_rule[count.index], "start_ip_address")
}

resource "azurerm_postgresql_active_directory_administrator" "this" {
  count               = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_active_directory_administrator)
  login               = lookup(var.postgresql_active_directory_administrator[count.index], "login")
  object_id           = data.azurerm_client_config.this.object_id
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_postgresql_server.this.*.name, lookup(var.postgresql_active_directory_administrator[count.index], "server_id"))
  tenant_id           = data.azurerm_client_config.this.tenant_id
}

resource "azurerm_postgresql_configuration" "this" {
  count               = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_configuration)
  name                = lookup(var.postgresql_configuration[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_postgresql_server.this.*.name, lookup(var.postgresql_configuration[count.index], "server_id"))
  value               = lookup(var.postgresql_configuration[count.index], "value")
}

resource "azurerm_postgresql_database" "this" {
  count               = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_database)
  charset             = lookup(var.postgresql_database[count.index], "charset")
  collation           = lookup(var.postgresql_database[count.index], "collation")
  name                = lookup(var.postgresql_database[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_postgresql_server.this.*.name, lookup(var.postgresql_database[count.index], "server_id"))
}

resource "azurerm_postgresql_firewall_rule" "this" {
  count               = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_firewall_rule)
  end_ip_address      = lookup(var.postgresql_firewall_rule[count.index], "end_ip_address")
  name                = lookup(var.postgresql_firewall_rule[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_postgresql_server.this.*.name, lookup(var.postgresql_firewall_rule[count.index], "server_id"))
  start_ip_address    = lookup(var.postgresql_firewall_rule[count.index], "start_ip_address")
}

resource "azurerm_postgresql_flexible_server" "this" {
  count                             = length(var.postgresql_flexible_server)
  location                          = data.azurerm_resource_group.this.location
  name                              = lookup(var.postgresql_flexible_server[count.index], "name")
  resource_group_name               = data.azurerm_resource_group.this.name
  administrator_login               = sensitive(lookup(var.postgresql_flexible_server[count.index], "administrator_login"))
  administrator_password            = sensitive(lookup(var.postgresql_flexible_server[count.index], "administrator_password"))
  backup_retention_days             = lookup(var.postgresql_flexible_server[count.index], "backup_retention_days")
  geo_redundant_backup_enabled      = lookup(var.postgresql_flexible_server[count.index], "geo_redundant_backup_enabled")
  create_mode                       = lookup(var.postgresql_flexible_server[count.index], "create_mode")
  delegated_subnet_id               = data.azurerm_subnet.this.id
  private_dns_zone_id               = data.azurerm_private_dns_zone.this.id
  public_network_access_enabled     = lookup(var.postgresql_flexible_server[count.index], "public_network_access_enabled")
  point_in_time_restore_time_in_utc = lookup(var.postgresql_flexible_server[count.index], "point_in_time_restore_time_in_utc")
  replication_role                  = lookup(var.postgresql_flexible_server[count.index], "replication_role")
  sku_name                          = lookup(var.postgresql_flexible_server[count.index], "sku_name")
  source_server_id                  = element(azurerm_postgresql_server.this.*.id, lookup(var.postgresql_flexible_server[count.index], "source_server_id"))
  auto_grow_enabled                 = lookup(var.postgresql_flexible_server[count.index], "auto_grow_enabled")
  storage_mb                        = lookup(var.postgresql_flexible_server[count.index], "storage_mb")
  storage_tier                      = lookup(var.postgresql_flexible_server[count.index], "storage_tier")
  tags                              = lookup(var.postgresql_flexible_server[count.index], "tags")
  version                           = lookup(var.postgresql_flexible_server[count.index], "version")
  zone                              = lookup(var.postgresql_flexible_server[count.index], "zone")

  /*dynamic "authentication" {
    for_each = ""
    content {
      active_directory_auth_enabled = true
      password_auth_enabled = true
      tenant_id = ""
    }
  }

  dynamic "customer_managed_key" {
    for_each         = ""
    content {
      key_vault_key_id = ""
      primary_user_assigned_identity_id = ""
      geo_backup_key_vault_key_id = ""
      geo_backup_user_assigned_identity_id = ""
    }
  }

  dynamic "high_availability" {
    for_each = ""
    content {
      mode = ""
      standby_availability_zone = ""
    }
  }

  dynamic "identity" {
    for_each     = ""
    content {
      identity_ids = []
      type = ""
    }
  }

  dynamic "maintenance_window" {
    for_each = ""
    content {
      day_of_week = 0
      start_hour = 0
      start_minute = 0
    }
  }*/
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "this" {
  count               = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_flexible_server_active_directory_administrator)
  object_id           = data.azuread_service_principal.this.object_id
  principal_name      = data.azuread_service_principal.this.display_name
  principal_type      = lookup(var.postgresql_flexible_server_active_directory_administrator[count.index], "principal_type")
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = element(azurerm_postgresql_server.this.*.name, lookup(var.postgresql_flexible_server_active_directory_administrator[count.index], "server_id"))
  tenant_id           = data.azurerm_client_config.this.tenant_id
}

resource "azurerm_postgresql_flexible_server_configuration" "this" {
  count     = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_flexible_server_configuration)
  name      = lookup(var.postgresql_flexible_server_configuration[count.index], "name")
  server_id = element(azurerm_postgresql_server.this.*.name, lookup(var.postgresql_flexible_server_configuration[count.index], "server_id"))
  value     = lookup(var.postgresql_flexible_server_configuration[count.index], "value")
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  count     = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_flexible_server_database)
  name      = lookup(var.postgresql_flexible_server_database[count.index], "name")
  server_id = element(azurerm_postgresql_server.this.*.id, lookup(var.postgresql_flexible_server_database[count.index], "server_id"))
  charset   = lookup(var.postgresql_flexible_server_database[count.index], "charset")
  collation = lookup(var.postgresql_flexible_server_database[count.index], "collation")
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  count            = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_flexible_server_firewall_rule)
  end_ip_address   = lookup(var.postgresql_flexible_server_firewall_rule[count.index], "end_ip_address")
  name             = lookup(var.postgresql_flexible_server_firewall_rule[count.index], "name")
  server_id        = element(azurerm_postgresql_server.this.*.id, lookup(var.postgresql_flexible_server_firewall_rule[count.index], "server_id"))
  start_ip_address = lookup(var.postgresql_flexible_server_firewall_rule[count.index], "start_ip_address")
}

resource "azurerm_postgresql_flexible_server_virtual_endpoint" "this" {
  count             = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_flexible_server_virtual_endpoint)
  name              = lookup(var.postgresql_flexible_server_virtual_endpoint[count.index], "name")
  replica_server_id = element(azurerm_postgresql_flexible_server.this.*.id, lookup(var.postgresql_flexible_server_virtual_endpoint[count.index], "replica_server_id"))
  source_server_id  = element(azurerm_postgresql_flexible_server.this.*.id, lookup(var.postgresql_flexible_server_virtual_endpoint[count.index], "source_server_id"))
  type              = lookup(var.postgresql_flexible_server_virtual_endpoint[count.index], "type")
}

resource "azurerm_postgresql_server" "this" {
  count                             = length(var.postgresql_server)
  location                          = data.azurerm_resource_group.this.location
  name                              = lookup(var.postgresql_server[count.index], "name")
  resource_group_name               = data.azurerm_resource_group.this.name
  sku_name                          = lookup(var.postgresql_server[count.index], "sku_name")
  ssl_enforcement_enabled           = lookup(var.postgresql_server[count.index], "ssl_enforcement_enabled")
  version                           = lookup(var.postgresql_server[count.index], "version")
  administrator_login               = sensitive(lookup(var.postgresql_server[count.index], "administrator_login"))
  administrator_login_password      = sensitive(lookup(var.postgresql_server[count.index], "administrator_login_password"))
  auto_grow_enabled                 = lookup(var.postgresql_server[count.index], "auto_grow_enabled")
  backup_retention_days             = lookup(var.postgresql_server[count.index], "backup_retention_days")
  create_mode                       = lookup(var.postgresql_server[count.index], "create_mode")
  creation_source_server_id         = element(azurerm_postgresql_server.this.*.id, lookup(var.postgresql_server[count.index], "creation_source_server_id"))
  geo_redundant_backup_enabled      = lookup(var.postgresql_server[count.index], "geo_redundant_backup_enabled")
  infrastructure_encryption_enabled = lookup(var.postgresql_server[count.index], "infrastructure_encryption_enabled")
  public_network_access_enabled     = lookup(var.postgresql_server[count.index], "public_network_access_enabled")
  restore_point_in_time             = lookup(var.postgresql_server[count.index], "restore_point_in_time")
  ssl_minimal_tls_version_enforced  = lookup(var.postgresql_server[count.index], "ssl_minimal_tls_version_enforced")
  storage_mb                        = lookup(var.postgresql_server[count.index], "storage_mb")
  tags                              = lookup(var.postgresql_server[count.index], "tags")
}

resource "azurerm_postgresql_server_key" "this" {
  count            = (length(var.postgresql_server) && (var.keyvault_key_name || length(var.keyvault_key))) == 0 ? 0 : length(var.postgresql_server_key)
  key_vault_key_id = var.keyvault_key_name ? data.azurerm_key_vault_key.this.id : element(module.keyvault.*.key_vault_key_id, lookup(var.postgresql_server_key[count.index], "key_vault_key_id"))
  server_id        = element(azurerm_postgresql_server.this.*.id, lookup(var.postgresql_server_key[count.index], "server_id"))
}

resource "azurerm_postgresql_virtual_network_rule" "this" {
  count                                = length(var.postgresql_server) == 0 ? 0 : length(var.postgresql_virtual_network_rule)
  name                                 = lookup(var.postgresql_virtual_network_rule[count.index], "name")
  resource_group_name                  = data.azurerm_resource_group.this.name
  server_name                          = element(azurerm_postgresql_server.this.*.name, lookup(var.postgresql_virtual_network_rule[count.index], "server_id"))
  subnet_id                            = data.azurerm_subnet.this.id
  ignore_missing_vnet_service_endpoint = true
}