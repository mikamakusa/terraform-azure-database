# azurerm_mssql_database
output "azurerm_mssql_database_id" {
  value = try(azurerm_mssql_database.this.*.id)
}

output "azurerm_mssql_database_name" {
  value = try(azurerm_mssql_database.this.*.name)
}
# azurerm_mssql_database_extended_auditing_policy
output "azurerm_mssql_database_extended_auditing_policy_id" {
  value = try(azurerm_mssql_database_extended_auditing_policy.this.*.id)
}

# azurerm_mssql_database_vulnerability_assessment_rule_baseline
output "azurerm_mssql_database_vulnerability_assessment_rule_baseline_id" {
  value = try(azurerm_mssql_database_vulnerability_assessment_rule_baseline.this.*.id)
}

output "azurerm_mssql_database_vulnerability_assessment_rule_baseline_name" {
  value = try(azurerm_mssql_database_vulnerability_assessment_rule_baseline.this.*.baseline_name)
}
# azurerm_mssql_elasticpool
output "azurerm_mssql_elasticpool_id" {
  value = try(azurerm_mssql_elasticpool.this.*.id)
}

output "azurerm_mssql_elasticpool_name" {
  value = try(azurerm_mssql_elasticpool.this.*.name)
}
# azurerm_mssql_failover_group
output "azurerm_mssql_failover_group_id" {
  value = try(azurerm_mssql_failover_group.this.*.id)
}

output "azurerm_mssql_failover_group_name" {
  value = try(azurerm_mssql_failover_group.this.*.name)
}
# azurerm_mssql_firewall_rule
output "azurerm_mssql_firewall_rule_id" {
  value = try(azurerm_mssql_firewall_rule.this.*.id)
}

output "azurerm_mssql_firewall_rule_name" {
  value = try(azurerm_mssql_firewall_rule.this.*.name)
}
# azurerm_mssql_job_agent
output "azurerm_mssql_job_agent_id" {
  value = try(azurerm_mssql_job_agent.this.*.id)
}

output "azurerm_mssql_job_agent_name" {
  value = try(azurerm_mssql_job_agent.this.*.name)
}
# azurerm_mssql_job_credential
output "azurerm_mssql_job_credential_id" {
  value = try(azurerm_mssql_job_credential.this.*.id)
}

output "azurerm_mssql_job_credential_name" {
  value = try(azurerm_mssql_job_credential.this.*.name)
}
# azurerm_mssql_managed_database
output "azurerm_mssql_managed_database_id" {
  value = try(azurerm_mssql_managed_database.this.*.id)
}

output "azurerm_mssql_managed_database_name" {
  value = try(azurerm_mssql_managed_database.this.*.name)
}
# azurerm_mssql_managed_instance
output "azurerm_mssql_managed_instance_id" {
  value = try(azurerm_mssql_managed_instance.this.*.id)
}

output "azurerm_mssql_managed_instance_name" {
  value = try(azurerm_mssql_managed_instance.this.*.name)
}
# azurerm_mssql_managed_instance_active_directory_administrator
output "azurerm_mssql_managed_instance_active_directory_administrator_id" {
  value = try(azurerm_mssql_managed_instance_active_directory_administrator.this.*.id)
}

# azurerm_mssql_managed_instance_failover_group
output "azurerm_mssql_managed_instance_failover_group_id" {
  value = try(azurerm_mssql_managed_instance_failover_group.this.*.id)
}

output "azurerm_mssql_managed_instance_failover_group_name" {
  value = try(azurerm_mssql_managed_instance_failover_group.this.*.name)
}
# azurerm_mssql_managed_instance_security_alert_policy
output "azurerm_mssql_managed_instance_security_alert_policy_id" {
  value = try(azurerm_mssql_managed_instance_security_alert_policy.this.*.id)
}

# azurerm_mssql_managed_instance_transparent_data_encryption
output "azurerm_mssql_managed_instance_transparent_data_encryption_id" {
  value = try(azurerm_mssql_managed_instance_transparent_data_encryption.this.*.id)
}

# azurerm_mssql_managed_instance_vulnerability_assessment
output "azurerm_mssql_managed_instance_vulnerability_assessment_id" {
  value = try(azurerm_mssql_managed_instance_vulnerability_assessment.this.*.id)
}

# azurerm_mssql_outbound_firewall_rule
output "azurerm_mssql_outbound_firewall_rule_id" {
  value = try(azurerm_mssql_outbound_firewall_rule.this.*.id)
}

output "azurerm_mssql_outbound_firewall_rule_name" {
  value = try(azurerm_mssql_outbound_firewall_rule.this.*.name)
}
# azurerm_mssql_server
output "azurerm_mssql_server_id" {
  value = try(azurerm_mssql_server.this.*.id)
}

output "mssql_server_fully_qualified_domain_name" {
  value = try(azurerm_mssql_server.this.*.fully_qualified_domain_name)
}

output "azurerm_mssql_server_name" {
  value = try(azurerm_mssql_server.this.*.name)
}
# azurerm_mssql_server_dns_alias
output "azurerm_mssql_server_dns_alias_id" {
  value = try(azurerm_mssql_server_dns_alias.this.*.id)
}

output "azurerm_mssql_server_dns_alias_name" {
  value = try(azurerm_mssql_server_dns_alias.this.*.name)
}
# azurerm_mssql_server_extended_auditing_policy
output "azurerm_mssql_server_extended_auditing_policy_id" {
  value = try(azurerm_mssql_server_extended_auditing_policy.this.*.id)
}

# azurerm_mssql_server_microsoft_support_auditing_policy
output "azurerm_mssql_server_microsoft_support_auditing_policy_id" {
  value = try(azurerm_mssql_server_microsoft_support_auditing_policy.this.*.id)
}

# azurerm_mssql_server_security_alert_policy
output "azurerm_mssql_server_security_alert_policy_id" {
  value = try(azurerm_mssql_server_security_alert_policy.this.*.id)
}

# azurerm_mssql_server_transparent_data_encryption
output "azurerm_mssql_server_transparent_data_encryption_id" {
  value = try(azurerm_mssql_server_transparent_data_encryption.this.*.id)
}
# azurerm_mssql_server_vulnerability_assessment
output "azurerm_mssql_server_vulnerability_assessment_id" {
  value = try(azurerm_mssql_server_vulnerability_assessment.this.*.id)
}
# azurerm_mssql_virtual_machine
output "azurerm_mssql_virtual_machine_id" {
  value = try(azurerm_mssql_virtual_machine.this.*.id)
}
# azurerm_mssql_virtual_machine_availability_group_listener
output "azurerm_mssql_virtual_machine_availability_group_listener_id" {
  value = try(azurerm_mssql_virtual_machine_availability_group_listener.this.*.id)
}

output "azurerm_mssql_virtual_machine_availability_group_listener_name" {
  value = try(azurerm_mssql_virtual_machine_availability_group_listener.this.*.name)
}
# azurerm_mssql_virtual_machine_group
output "azurerm_mssql_virtual_machine_group_id" {
  value = try(azurerm_mssql_virtual_machine_group.this.*.id)
}

output "azurerm_mssql_virtual_machine_group_name" {
  value = try(azurerm_mssql_virtual_machine_group.this.*.name)
}
# azurerm_mssql_virtual_network_rule
output "azurerm_mssql_virtual_network_rule_id" {
  value = try(azurerm_mssql_virtual_network_rule.this.*.id)
}

output "azurerm_mssql_virtual_network_rule_name" {
  value = try(azurerm_mssql_virtual_network_rule.this.*.name)
}
# azurerm_mysql_flexible_database
output "azurerm_mysql_flexible_database_id" {
  value = try(azurerm_mysql_flexible_database.this.*.id)
}

output "azurerm_mysql_flexible_database_name" {
  value = try(azurerm_mysql_flexible_database.this.*.name)
}
# azurerm_mysql_flexible_server
output "azurerm_mysql_flexible_server_id" {
  value = try(azurerm_mysql_flexible_server.this.*.id)
}

output "azurerm_mysql_flexible_server_name" {
  value = try(azurerm_mysql_flexible_server.this.*.name)
}
# azurerm_mysql_flexible_server_active_directory_administrator
output "azurerm_mysql_flexible_server_active_directory_administrator_id" {
  value = try(azurerm_mysql_flexible_server_active_directory_administrator.this.*.id)
}
# azurerm_mysql_flexible_server_configuration
output "azurerm_mysql_flexible_server_configuration_id" {
  value = try(azurerm_mysql_flexible_server_configuration.this.*.id)
}

output "azurerm_mysql_flexible_server_configuration_name" {
  value = try(azurerm_mysql_flexible_server_configuration.this.*.name)
}
# azurerm_mysql_flexible_server_firewall_rule
output "azurerm_mysql_flexible_server_firewall_rule_id" {
  value = try(azurerm_mysql_flexible_server_firewall_rule.this.*.id)
}

output "azurerm_mysql_flexible_server_firewall_rule_name" {
  value = try(azurerm_mysql_flexible_server_firewall_rule.this.*.name)
}