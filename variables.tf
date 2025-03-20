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

variable "virtual_network_name" {
  type    = string
  default = null
}

variable "subnet_name" {
  type    = string
  default = null
}

variable "azuread_user_name" {
  type    = string
  default = null
}

variable "virtual_machine_name" {
  type    = string
  default = null
}

variable "lb_name" {
  type    = string
  default = null
}

variable "private_dns_zone_name" {
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
    id           = any
    job_agent_id = any
    name         = string
    password     = string
    username     = string
  }))
  default = []
}

variable "mssql_managed_database" {
  type = list(object({
    id                        = any
    managed_instance_id       = any
    name                      = string
    short_term_retention_days = optional(number)
    long_term_retention_policy = optional(list(object({
      weekly_retention  = any
      monthly_retention = any
      yearly_retention  = any
      week_of_year      = any
    })))
    point_in_time_restore = optional(list(object({
      restore_point_in_time = any
      source_database_id    = any
    })))
  }))
  default = []
}

variable "mssql_managed_instance" {
  type = list(object({
    id                           = any
    administrator_login          = string
    administrator_login_password = string
    license_type                 = string
    name                         = string
    sku_name                     = string
    storage_size_in_gb           = string
    vcores                       = string
  }))
  default = []
}

variable "mssql_managed_instance_active_directory_administrator" {
  type = list(object({
    id                          = any
    login_username              = string
    managed_instance_id         = any
    azuread_authentication_only = optional(bool)
  }))
  default = []
}

variable "mssql_managed_instance_failover_group" {
  type = list(object({
    id                                        = any
    managed_instance_id                       = any
    name                                      = string
    partner_managed_instance_id               = any
    readonly_endpoint_failover_policy_enabled = optional(bool)
    secondary_type                            = optional(string)
    read_write_endpoint_failover_policy = optional(list(object({
      mode          = string
      grace_minutes = optional(string)
    })))
  }))
  default = []
}

variable "mssql_managed_instance_security_alert_policy" {
  type = list(object({
    id                           = any
    managed_instance_id          = any
    disabled_alerts              = optional(set(string))
    enabled                      = optional(bool)
    email_account_admins_enabled = optional(bool)
    email_addresses              = optional(set(string))
    retention_days               = optional(number)
    storage_account_id           = optional(any)
  }))
  default = []
}

variable "mssql_managed_instance_transparent_data_encryption" {
  type = list(object({
    id                  = any
    managed_instance_id = any
    key_vault_key_id    = optional(any)
  }))
  default = []
}

variable "mssql_managed_instance_vulnerability_assessment" {
  type = list(object({
    id                   = any
    managed_instance_id  = any
    storage_account_id   = any
    storage_container_id = any
    recurring_scans = optional(list(object({
      enabled                   = optional(bool)
      email_subscription_admins = optional(bool)
      emails                    = optional(list(string))
    })), [])
  }))
  default = []
}

variable "mssql_outbound_firewall_rule" {
  type = list(object({
    id        = any
    name      = string
    server_id = any
  }))
  default = []
}

variable "mssql_server" {
  type = list(object({
    id                                           = any
    name                                         = string
    version                                      = string
    administrator_login                          = optional(string)
    administrator_login_password                 = optional(string)
    connection_policy                            = optional(string)
    transparent_data_encryption_key_vault_key_id = optional(any)
    minimum_tls_version                          = optional(string)
    public_network_access_enabled                = optional(bool)
    outbound_network_restriction_enabled         = optional(bool)
    primary_user_assigned_identity_id            = optional(any)
    tags                                         = optional(map(string))
    azuread_administrator = optional(list(object({
      login_username              = string
      object_id                   = any
      tenant_id                   = optional(any)
      azuread_authentication_only = optional(bool)
    })), [])
    identity = optional(list(object({
      type         = string
      identity_ids = optional(list(any))
    })), [])
  }))
  default = []
}

variable "mssql_server_dns_alias" {
  type = list(object({
    id              = any
    mssql_server_id = any
    name            = string
  }))
  default = []
}

variable "mssql_server_extended_auditing_policy" {
  type = list(object({
    id                                      = any
    server_id                               = any
    enabled                                 = optional(bool)
    storage_endpoint                        = optional(any)
    retention_in_days                       = optional(number)
    storage_account_id                      = optional(any)
    storage_account_access_key_is_secondary = optional(bool)
    log_monitoring_enabled                  = optional(bool)
    predicate_expression                    = optional(string)
    audit_actions_and_groups                = optional(set(string))
  }))
  default = []
}

variable "support_auditing_policy" {
  type = list(object({
    id                     = any
    server_id              = any
    enabled                = optional(bool)
    storage_account_id     = optional(any)
    log_monitoring_enabled = optional(bool)
  }))
  default = []
}

variable "mssql_server_security_alert_policy" {
  type = list(object({
    id                   = any
    server_id            = any
    state                = string
    disabled_alerts      = optional(list(string))
    email_account_admins = optional(bool)
    email_addresses      = optional(list(string))
    retention_days       = optional(number)
  }))
  default = []
}

variable "mssql_server_transparent_data_encryption" {
  type = list(object({
    id               = any
    server_id        = any
    key_vault_key_id = optional(any)
  }))
  default = []
}

variable "mssql_server_vulnerability_assessment" {
  type = list(object({
    id                              = any
    server_security_alert_policy_id = any
    storage_account_id              = any
    storage_container_id            = any
    recurring_scans = optional(list(object({
      enabled                   = optional(bool)
      email_subscription_admins = optional(bool)
      emails                    = optional(list(string))
    })), [])
  }))
  default = []
}

variable "mssql_virtual_machine" {
  type = list(object({
    id                               = any
    virtual_machine_id               = optional(any)
    sql_license_type                 = optional(string)
    r_services_enabled               = optional(bool)
    sql_connectivity_port            = optional(number)
    sql_connectivity_type            = optional(string)
    sql_connectivity_update_password = optional(string)
    sql_connectivity_update_username = optional(string)
    tags                             = optional(map(string))
    auto_backup = optional(list(object({
      retention_period_in_days = number
      storage_account_id       = any
      encryption_enabled       = optional(bool)
      encryption_password      = optional(string)
      manual_schedule = optional(list(object({
        full_backup_frequency           = optional(string)
        full_backup_start_hour          = optional(number)
        full_backup_window_in_hours     = optional(number)
        log_backup_frequency_in_minutes = optional(number)
        days_of_week                    = optional(list(string))
      })), [])
    })), [])
    auto_patching = optional(list(object({
      day_of_week                            = string
      maintenance_window_duration_in_minutes = number
      maintenance_window_starting_hour       = number
    })), [])
    key_vault_credential = optional(list(object({
      key_vault_url            = string
      name                     = string
      service_principal_name   = string
      service_principal_secret = string
    })), [])
    sql_instance = optional(list(object({
      adhoc_workloads_optimization_enabled = optional(bool)
      collation                            = optional(string)
      instant_file_initialization_enabled  = optional(bool)
      lock_pages_in_memory_enabled         = optional(bool)
      max_dop                              = optional(number)
      max_server_memory_mb                 = optional(number)
      min_server_memory_mb                 = optional(number)
    })), [])
    storage_configuration = optional(list(object({
      disk_type             = string
      storage_workload_type = string
    })), [])
    wsfc_domain_credential = optional(list(object({
      cluster_bootstrap_account_password = string
      cluster_operator_account_password  = string
      sql_service_account_password       = string
    })), [])
  }))
  default = []
}

variable "mssql_virtual_machine_availability_group_listener" {
  type = list(object({
    id                           = any
    name                         = string
    sql_virtual_machine_group_id = any
    availability_group_name      = optional(string)
    port                         = optional(number)
    load_balancer_configuration = optional(list(object({
      load_balancer_id        = any
      private_ip_address      = string
      probe_port              = number
      sql_virtual_machine_ids = list(any)
      subnet_id               = any
    })), [])
    multi_subnet_ip_configuration = optional(list(object({
      private_ip_address     = string
      sql_virtual_machine_id = any
      subnet_id              = any
    })), [])
    replica = optional(list(object({
      commit                 = string
      failover_mode          = string
      readable_secondary     = string
      role                   = string
      sql_virtual_machine_id = any
    })), [])
  }))
  default = []
}

variable "mssql_virtual_machine_group" {
  type = list(object({
    id              = any
    name            = string
    sql_image_offer = string
    sql_image_sku   = string
    tags            = map(string)
  }))
  default = []
}

variable "mssql_virtual_network_rule" {
  type = list(object({
    id                                   = any
    name                                 = string
    server_id                            = any
    ignore_missing_vnet_service_endpoint = optional(bool)
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

variable "postgresql_active_directory_administrator" {
  type = list(object({
    id        = any
    login     = string
    server_id = any
  }))
  default = []
}

variable "postgresql_configuration" {
  type = list(object({
    id        = any
    name      = string
    server_id = any
    value     = string
  }))
  default = []
}

variable "postgresql_database" {
  type = list(object({
    id        = any
    charset   = string
    collation = string
    name      = string
    server_id = any
  }))
  default = []
}

variable "postgresql_firewall_rule" {
  type = list(object({
    id               = any
    end_ip_address   = string
    name             = string
    server_id        = any
    start_ip_address = string
  }))
  default = []
}

variable "postgresql_flexible_server" {
  type = list(object({
    id                                = any
    name                              = string
    administrator_login               = optional(string)
    administrator_password            = optional(string)
    backup_retention_days             = optional(number)
    geo_redundant_backup_enabled      = optional(bool)
    create_mode                       = optional(string)
    public_network_access_enabled     = optional(bool)
    point_in_time_restore_time_in_utc = optional(string)
    replication_role                  = optional(string)
    sku_name                          = optional(string)
    source_server_id                  = optional(any)
    auto_grow_enabled                 = optional(bool)
    storage_mb                        = optional(number)
    storage_tier                      = optional(string)
    tags                              = optional(map(string))
    version                           = optional(string)
    zone                              = optional(string)
  }))
  default = []
}

variable "postgresql_flexible_server_active_directory_administrator" {
  type = list(object({
    id             = any
    principal_type = string
    server_id      = any
  }))
  default = []
}

variable "postgresql_flexible_server_configuration" {
  type = list(object({
    id        = any
    name      = string
    server_id = any
    value     = string
  }))
  default = []
}

variable "postgresql_flexible_server_database" {
  type = list(object({
    id        = any
    name      = string
    server_id = any
    charset   = optional(string)
    collation = optional(string)
  }))
  default = []
}

variable "postgresql_flexible_server_firewall_rule" {
  type = list(object({
    id               = any
    end_ip_address   = string
    name             = string
    server_id        = any
    start_ip_address = string
  }))
  default = []
}

variable "postgresql_flexible_server_virtual_endpoint" {
  type = list(object({
    id                = any
    name              = string
    replica_server_id = any
    source_server_id  = any
    type              = string
  }))
  default = []
}

variable "postgresql_server" {
  type = list(object({
    id                                = any
    name                              = string
    sku_name                          = string
    ssl_enforcement_enabled           = bool
    version                           = string
    administrator_login               = optional(string)
    administrator_login_password      = optional(string)
    auto_grow_enabled                 = optional(bool)
    backup_retention_days             = optional(number)
    create_mode                       = optional(string)
    creation_source_server_id         = optional(any)
    geo_redundant_backup_enabled      = optional(bool)
    infrastructure_encryption_enabled = optional(bool)
    public_network_access_enabled     = optional(bool)
    restore_point_in_time             = optional(string)
    ssl_minimal_tls_version_enforced  = optional(string)
    storage_mb                        = optional(number)
    tags                              = optional(map(string))
  }))
  default = []
}

variable "postgresql_server_key" {
  type = list(object({
    id               = any
    key_vault_key_id = any
    server_id        = any
  }))
  default = []
}

variable "postgresql_virtual_network_rule" {
  type = list(object({
    id        = any
    name      = string
    server_id = any
  }))
  default = []
}
