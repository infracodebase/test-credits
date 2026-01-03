# Azure Key Vault configuration

# Data source to get current client configuration
data "azurerm_client_config" "current" {}

# Create Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_name

  # Enable features
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days

  # Network access configuration
  public_network_access_enabled = var.key_vault_public_network_access_enabled

  # Network ACLs
  network_acls {
    bypass                     = var.key_vault_network_acls_bypass
    default_action             = var.key_vault_network_acls_default_action
    ip_rules                   = var.key_vault_network_acls_ip_rules
    virtual_network_subnet_ids = concat(
      var.key_vault_network_acls_subnet_ids,
      var.enable_key_vault_private_endpoint ? [azurerm_subnet.private_endpoint.id] : []
    )
  }

  # Access policy for current client (creator)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Decrypt",
      "Encrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge",
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge",
    ]
  }

  # Lifecycle management
  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}