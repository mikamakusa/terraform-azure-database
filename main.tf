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
  job_agent_id = ""
  name         = ""
  password     = ""
  username     = ""
}

resource "azurerm_mssql_managed_database" "this" {
  count               = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_database)
  managed_instance_id = ""
  name                = ""
}

resource "azurerm_mssql_managed_instance" "this" {
  count                        = length(var.mssql_managed_instance)
  administrator_login          = ""
  administrator_login_password = ""
  license_type                 = ""
  location                     = ""
  name                         = ""
  resource_group_name          = ""
  sku_name                     = ""
  storage_size_in_gb           = 0
  subnet_id                    = ""
  vcores                       = 0
}

resource "azurerm_mssql_managed_instance_active_directory_administrator" "this" {
  count               = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_active_directory_administrator)
  login_username      = ""
  managed_instance_id = ""
  object_id           = ""
  tenant_id           = ""
}

resource "azurerm_mssql_managed_instance_failover_group" "this" {
  count                       = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_failover_group)
  location                    = ""
  managed_instance_id         = ""
  name                        = ""
  partner_managed_instance_id = ""
}

resource "azurerm_mssql_managed_instance_security_alert_policy" "this" {
  count                 = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_security_alert_policy)
  managed_instance_name = ""
  resource_group_name   = ""
}

resource "azurerm_mssql_managed_instance_transparent_data_encryption" "this" {
  count               = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_transparent_data_encryption)
  managed_instance_id = ""
}

resource "azurerm_mssql_managed_instance_vulnerability_assessment" "this" {
  count                  = length(var.mssql_managed_instance) == 0 ? 0 : length(var.mssql_managed_instance_vulnerability_assessment)
  managed_instance_id    = ""
  storage_container_path = ""
}

resource "azurerm_mssql_outbound_firewall_rule" "this" {
  count     = length(var.mssql_server) == 0 ? 0 : length(var.mssql_outbound_firewall_rule)
  name      = ""
  server_id = ""
}

resource "azurerm_mssql_server" "this" {
  count               = length(var.mssql_server)
  location            = ""
  name                = ""
  resource_group_name = ""
  version             = ""
}

resource "azurerm_mssql_server_dns_alias" "this" {
  count           = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_dns_alias)
  mssql_server_id = ""
  name            = ""
}

resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  count     = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_extended_auditing_policy)
  server_id = ""
}

resource "azurerm_mssql_server_security_alert_policy" "this" {
  count               = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_security_alert_policy)
  resource_group_name = ""
  server_name         = ""
  state               = ""
}

resource "azurerm_mssql_server_transparent_data_encryption" "this" {
  count     = length(var.mssql_server) == 0 ? 0 : length(var.mssql_server_transparent_data_encryption)
  server_id = ""
}

resource "azurerm_mssql_server_vulnerability_assessment" "this" {
  count                           = length(var.mssql_server_security_alert_policy) == 0 ? 0 : length(var.mssql_server_vulnerability_assessment)
  server_security_alert_policy_id = ""
  storage_container_path          = ""
}

resource "azurerm_mssql_virtual_machine" "this" {
  count              = length(var.mssql_virtual_machine)
  virtual_machine_id = ""
}

resource "azurerm_mssql_virtual_machine_availability_group_listener" "this" {
  count                        = length(var.mssql_virtual_machine_group) == 0 ? 0 : length(var.mssql_virtual_machine_availability_group_listener)
  name                         = ""
  sql_virtual_machine_group_id = ""
}

resource "azurerm_mssql_virtual_machine_group" "this" {
  count               = length(var.mssql_virtual_machine_group)
  location            = ""
  name                = ""
  resource_group_name = ""
  sql_image_offer     = ""
  sql_image_sku       = ""
}

resource "azurerm_mssql_virtual_network_rule" "this" {
  count     = length(var.mssql_server) == 0 ? 0 : length(var.mssql_virtual_network_rule)
  name      = ""
  server_id = ""
  subnet_id = ""
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