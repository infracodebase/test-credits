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