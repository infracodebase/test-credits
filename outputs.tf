# Output values for the Azure resource group

output "resource_group_id" {
  description = "The ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "The location of the created resource group"
  value       = azurerm_resource_group.main.location
}

output "resource_group_tags" {
  description = "The tags applied to the resource group"
  value       = azurerm_resource_group.main.tags
}

# Azure Key Vault Outputs

output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
  value       = azurerm_key_vault.main.tenant_id
}

output "key_vault_sku_name" {
  description = "The Name of the SKU used for this Key Vault"
  value       = azurerm_key_vault.main.sku_name
}

# Private Endpoint Outputs

output "virtual_network_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "virtual_network_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "private_endpoint_subnet_id" {
  description = "The ID of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoint.id
}

output "key_vault_private_endpoint_id" {
  description = "The ID of the Key Vault private endpoint"
  value       = var.enable_key_vault_private_endpoint ? azurerm_private_endpoint.key_vault[0].id : null
}

output "key_vault_private_endpoint_private_ip" {
  description = "The private IP address of the Key Vault private endpoint"
  value       = var.enable_key_vault_private_endpoint ? azurerm_private_endpoint.key_vault[0].private_service_connection[0].private_ip_address : null
}

output "private_dns_zone_id" {
  description = "The ID of the private DNS zone for Key Vault"
  value       = azurerm_private_dns_zone.key_vault.id
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group for private endpoints"
  value       = azurerm_network_security_group.private_endpoint.id
}

# Function App Outputs

output "function_app_id" {
  description = "The ID of the Function App"
  value       = var.function_app_os_type == "Linux" ? azurerm_linux_function_app.main[0].id : azurerm_windows_function_app.main[0].id
}

output "function_app_name" {
  description = "The name of the Function App"
  value       = var.function_app_name
}

output "function_app_default_hostname" {
  description = "The default hostname of the Function App"
  value       = var.function_app_os_type == "Linux" ? azurerm_linux_function_app.main[0].default_hostname : azurerm_windows_function_app.main[0].default_hostname
}

output "function_app_identity_principal_id" {
  description = "The Principal ID of the Function App's system-assigned identity"
  value       = var.function_app_os_type == "Linux" ? azurerm_linux_function_app.main[0].identity[0].principal_id : azurerm_windows_function_app.main[0].identity[0].principal_id
}

output "service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.function_app.id
}

output "function_app_storage_account_id" {
  description = "The ID of the Function App storage account"
  value       = azurerm_storage_account.function_app.id
}

output "function_app_storage_account_name" {
  description = "The name of the Function App storage account"
  value       = azurerm_storage_account.function_app.name
}

output "application_insights_id" {
  description = "The ID of the Application Insights resource"
  value       = var.enable_application_insights ? azurerm_application_insights.function_app[0].id : null
}

output "application_insights_instrumentation_key" {
  description = "The instrumentation key for Application Insights"
  value       = var.enable_application_insights ? azurerm_application_insights.function_app[0].instrumentation_key : null
  sensitive   = true
}

# Storage Private Endpoint Outputs

output "storage_blob_private_endpoint_id" {
  description = "The ID of the storage blob private endpoint"
  value       = var.enable_storage_private_endpoint ? azurerm_private_endpoint.storage_blob[0].id : null
}

output "storage_queue_private_endpoint_id" {
  description = "The ID of the storage queue private endpoint"
  value       = var.enable_storage_private_endpoint ? azurerm_private_endpoint.storage_queue[0].id : null
}

output "storage_table_private_endpoint_id" {
  description = "The ID of the storage table private endpoint"
  value       = var.enable_storage_private_endpoint ? azurerm_private_endpoint.storage_table[0].id : null
}

output "storage_file_private_endpoint_id" {
  description = "The ID of the storage file private endpoint"
  value       = var.enable_storage_private_endpoint ? azurerm_private_endpoint.storage_file[0].id : null
}

output "storage_private_dns_zone_ids" {
  description = "The IDs of the storage private DNS zones"
  value = {
    blob  = azurerm_private_dns_zone.storage_blob.id
    queue = azurerm_private_dns_zone.storage_queue.id
    table = azurerm_private_dns_zone.storage_table.id
    file  = azurerm_private_dns_zone.storage_file.id
  }
}