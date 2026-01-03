# Virtual Network for Private Endpoint
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Subnet for Private Endpoints
resource "azurerm_subnet" "private_endpoint" {
  name                 = var.private_endpoint_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_endpoint_subnet_address_prefixes

  # Disable private endpoint network policies
  private_endpoint_network_policies_enabled = false
}

# Private DNS Zone for Key Vault
resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "kv-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false

  tags = var.tags
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "key_vault" {
  count               = var.enable_key_vault_private_endpoint ? 1 : 0
  name                = var.key_vault_private_endpoint_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "kv-private-connection"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  tags = var.tags
}

# Network Security Group for Private Endpoint Subnet
resource "azurerm_network_security_group" "private_endpoint" {
  name                = var.private_endpoint_nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Allow inbound HTTPS traffic to Key Vault
  security_rule {
    name                       = "AllowKeyVaultInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.vnet_address_space[0]
    destination_address_prefix = "*"
  }

  # Allow outbound traffic to Key Vault
  security_rule {
    name                       = "AllowKeyVaultOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = var.vnet_address_space[0]
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with Private Endpoint Subnet
resource "azurerm_subnet_network_security_group_association" "private_endpoint" {
  subnet_id                 = azurerm_subnet.private_endpoint.id
  network_security_group_id = azurerm_network_security_group.private_endpoint.id
}

# Private DNS Zone for Storage Account
resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Link Storage Blob Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob" {
  name                  = "storage-blob-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_blob.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false

  tags = var.tags
}

# Private DNS Zone for Storage Queue
resource "azurerm_private_dns_zone" "storage_queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Link Storage Queue Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "storage_queue" {
  name                  = "storage-queue-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_queue.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false

  tags = var.tags
}

# Private DNS Zone for Storage Table
resource "azurerm_private_dns_zone" "storage_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Link Storage Table Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "storage_table" {
  name                  = "storage-table-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_table.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false

  tags = var.tags
}

# Private DNS Zone for Storage File
resource "azurerm_private_dns_zone" "storage_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Link Storage File Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "storage_file" {
  name                  = "storage-file-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_file.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false

  tags = var.tags
}

# Private Endpoint for Storage Account - Blob
resource "azurerm_private_endpoint" "storage_blob" {
  count               = var.enable_storage_private_endpoint ? 1 : 0
  name                = var.storage_blob_private_endpoint_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "storage-blob-private-connection"
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-blob-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_blob.id]
  }

  tags = var.tags
}

# Private Endpoint for Storage Account - Queue
resource "azurerm_private_endpoint" "storage_queue" {
  count               = var.enable_storage_private_endpoint ? 1 : 0
  name                = var.storage_queue_private_endpoint_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "storage-queue-private-connection"
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-queue-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_queue.id]
  }

  tags = var.tags
}

# Private Endpoint for Storage Account - Table
resource "azurerm_private_endpoint" "storage_table" {
  count               = var.enable_storage_private_endpoint ? 1 : 0
  name                = var.storage_table_private_endpoint_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "storage-table-private-connection"
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-table-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_table.id]
  }

  tags = var.tags
}

# Private Endpoint for Storage Account - File
resource "azurerm_private_endpoint" "storage_file" {
  count               = var.enable_storage_private_endpoint ? 1 : 0
  name                = var.storage_file_private_endpoint_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "storage-file-private-connection"
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-file-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_file.id]
  }

  tags = var.tags
}