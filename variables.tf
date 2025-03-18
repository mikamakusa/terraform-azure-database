## DATAS

variable "resource_group_name" {
  type = string
}

variable "user_assigned_identity_name" {
  type = string
}

variable "keyvault_name" {
  type    = string
  default = null
}

variable "keyvault_key_name" {
  type    = string
  default = null
}

variable "storage_account_name" {
  type    = string
  default = null
}

variable "storage_container_name" {
  type    = string
  default = null
}

## MODULES

variable "keyvault" {
  type    = any
  default = []
}

variable "keyvault_key" {
  type    = any
  default = []
}

variable "storage_account" {
  type    = any
  default = []
}

variable "storage_container" {
  type    = any
  default = []
}

## RESOURCES

variable "mssql_database" {
  type = list(object({
    id                                                         = any
    name                                                       = string
    server_id                                                  = any
    auto_pause_delay_in_minutes                                = optional(number)
    create_mode                                                = optional(string)
    creation_source_database_id                                = optional(any)
    collation                                                  = optional(string)
    elastic_pool_id                                            = optional(any)
    enclave_type                                               = optional(string)
    geo_backup_enabled                                         = optional(bool)
    maintenance_configuration_name                             = optional(string)
    ledger_enabled                                             = optional(bool)
    license_type                                               = optional(string)
    max_size_gb                                                = optional(number)
    min_capacity                                               = optional(number)
    restore_point_in_time                                      = optional(string)
    recovery_point_id                                          = optional(any)
    recover_database_id                                        = optional(any)
    restore_dropped_database_id                                = optional(any)
    restore_long_term_retention_backup_id                      = optional(any)
    read_replica_count                                         = optional(number)
    read_scale                                                 = optional(bool)
    sample_name                                                = optional(string)
    sku_name                                                   = optional(string)
    storage_account_type                                       = optional(string)
    transparent_data_encryption_enabled                        = optional(bool)
    transparent_data_encryption_key_automatic_rotation_enabled = optional(bool)
    transparent_data_encryption_key_vault_key_id               = optional(any)
    zone_redundant                                             = optional(bool)
    secondary_type                                             = optional(string)
    tags                                                       = optional(map(string))
    import = optional(list(object({
      administrator_login          = string
      administrator_login_password = string
      authentication_type          = string
      storage_key                  = string
      storage_key_type             = string
      storage_uri                  = string
      storage_account_id           = optional(any)
    })), [])
    long_term_retention_policy = optional(list(object({
      weekly_retention          = optional(string)
      monthly_retention         = optional(string)
      yearly_retention          = optional(string)
      week_of_year              = optional(number)
      immutable_backups_enabled = optional(bool)
    })), [])
    short_term_retention_policy = optional(list(object({
      retention_days           = number
      backup_interval_in_hours = optional(number)
    })), [])
    threat_detection_policy = optional(list(object({
      state                      = optional(string)
      disabled_alerts            = optional(list(string))
      email_account_admins       = optional(string)
      email_addresses            = optional(list(string))
      retention_days             = optional(number)
      storage_account_access_key = optional(string)
      storage_endpoint           = optional(string)
    })), [])
  }))
  default = []
}

variable "mssql_database_extended_auditing_policy" {
  type = list(object({
    id                                      = any
    database_id                             = any
    storage_id                              = optional(any)
    retention_in_days                       = optional(number)
    storage_account_access_key_is_secondary = optional(bool)
    log_monitoring_enabled                  = optional(bool)
  }))
  default = []
}

variable "mssql_database_vulnerability_assessment_rule_baseline" {
  type = list(object({
    id                                 = any
    database_id                        = any
    rule_id                            = string
    server_vulnerability_assessment_id = any
    baseline_name                      = optional(string)
    baseline_result = optional(list(object({
      result = list(string)
    })), [])
  }))
  default = []
}

variable "mssql_elasticpool" {
  type = list(object({
    id                             = any
    name                           = string
    server_id                      = any
    maintenance_configuration_name = optional(string)
    max_size_bytes                 = optional(number)
    max_size_gb                    = optional(number)
    enclave_type                   = optional(string)
    tags                           = optional(map(string))
    zone_redundant                 = optional(bool)
    license_type                   = optional(string)
    per_database_settings = optional(list(object({
      max_capacity = number
      min_capacity = number
    })), [])
    sku = optional(list(object({
      capacity = number
      name     = string
      tier     = string
      family   = optional(string)
    })), [])
  }))
  default = []
}

variable "mssql_failover_group" {
  type = list(object({
    id                                        = any
    name                                      = string
    server_id                                 = any
    databases                                 = optional(list(string))
    readonly_endpoint_failover_policy_enabled = optional(bool)
    tags                                      = optional(map(string))
    partner_server = optional(list(object({
      id = any
    })), [])
    read_write_endpoint_failover_policy = optional(list(object({
      mode          = string
      grace_minutes = number
    })), [])
  }))
  default = []
}

variable "mssql_firewall_rule" {
  type = list(object({
    id               = any
    end_ip_address   = string
    name             = string
    server_id        = any
    start_ip_address = string
  }))
  default = []
}

variable "mssql_job_agent" {
  type = list(object({
    id          = any
    database_id = any
    name        = string
    tags        = optional(map(string))
  }))
  default = []
}

variable "mssql_job_credential" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_managed_database" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_managed_instance" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_managed_instance_active_directory_administrator" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_managed_instance_failover_group" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_managed_instance_security_alert_policy" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_managed_instance_transparent_data_encryption" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_managed_instance_vulnerability_assessment" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_outbound_firewall_rule" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_server" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_server_dns_alias" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_server_extended_auditing_policy" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_server_security_alert_policy" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_server_transparent_data_encryption" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_server_vulnerability_assessment" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_virtual_machine" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_virtual_machine_availability_group_listener" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_virtual_machine_group" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mssql_virtual_network_rule" {
  type = list(object({
    id = any
  }))
  default = []
}

variable "mysql_flexible_database" {
  type = list(object({
    id        = any
    charset   = string
    collation = string
    name      = string
    server_id = any
  }))
  default = []
}

variable "mysql_flexible_server" {
  type = list(object({
    id                                = any
    name                              = string
    administrator_login               = optional(string)
    administrator_password            = optional(string)
    backup_retention_days             = optional(number)
    create_mode                       = optional(string)
    delegated_subnet_id               = optional(string)
    geo_redundant_backup_enabled      = optional(bool)
    point_in_time_restore_time_in_utc = optional(string)
    private_dns_zone_id               = optional(string)
    replication_role                  = optional(string)
    sku_name                          = optional(string)
    source_server_id                  = optional(string)
    version                           = optional(string)
    zone                              = optional(string)
    tags                              = optional(map(string))
    customer_managed_key = optional(list(object({
      key_vault_key_id = optional(any)
    })), [])
    high_availability = optional(list(object({
      mode                      = optional(string)
      standby_availability_zone = optional(string)
    })), [])
    identity = optional(list(object({
      identity_ids = list(any)
    })), [])
    maintenance_window = optional(list(object({
      day_of_week  = optional(number)
      start_hour   = optional(number)
      start_minute = optional(number)
    })), [])
    storage = optional(list(object({
      auto_grow_enabled  = optional(bool)
      io_scaling_enabled = optional(bool)
      iops               = optional(number)
      size_gb            = optional(number)
    })), [])
  }))
  default = []
}

variable "mysql_flexible_server_active_directory_administrator" {
  type = list(object({
    id        = any
    login     = string
    server_id = any
  }))
  default = []
}

variable "mysql_flexible_server_configuration" {
  type = list(object({
    id        = any
    name      = string
    server_id = any
    value     = string
  }))
  default = []
}

variable "mysql_flexible_server_firewall_rule" {
  type = list(object({
    id               = any
    end_ip_address   = string
    name             = string
    server_name      = any
    start_ip_address = string
  }))
  default = []
}
