# Variable declarations for Azure resource group

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }
}

variable "location" {
  description = "Azure region where the resource group will be created"
  type        = string
  default     = "East US"
  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US",
      "West Central US", "Canada Central", "Canada East",
      "Brazil South", "North Europe", "West Europe", "UK South",
      "UK West", "France Central", "Germany West Central",
      "Switzerland North", "Norway East", "Sweden Central",
      "Australia East", "Australia Southeast", "Australia Central",
      "Japan East", "Japan West", "Korea Central", "Asia Pacific",
      "Southeast Asia", "East Asia", "India Central", "India South",
      "India West", "UAE North", "South Africa North"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "tags" {
  description = "Tags to apply to the resource group"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# Optional Azure Provider Configuration Variables
# Uncomment and use these if you need to specify Azure credentials explicitly

# variable "subscription_id" {
#   description = "Azure subscription ID to use for resources"
#   type        = string
#   default     = null
#   sensitive   = true
# }

# variable "tenant_id" {
#   description = "Azure tenant ID for authentication"
#   type        = string
#   default     = null
#   sensitive   = true
# }

# variable "client_id" {
#   description = "Azure service principal client ID"
#   type        = string
#   default     = null
#   sensitive   = true
# }

# variable "client_secret" {
#   description = "Azure service principal client secret"
#   type        = string
#   default     = null
#   sensitive   = true
# }

# Azure Key Vault Variables

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
  validation {
    condition     = length(var.key_vault_name) >= 3 && length(var.key_vault_name) <= 24 && can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.key_vault_name))
    error_message = "Key Vault name must be between 3-24 characters, start with a letter, end with a letter or digit, and contain only alphanumeric characters and hyphens."
  }
}

variable "key_vault_sku_name" {
  description = "The Name of the SKU used for this Key Vault"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku_name)
    error_message = "Key Vault SKU must be either 'standard' or 'premium'."
  }
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys"
  type        = bool
  default     = false
}

variable "key_vault_enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault"
  type        = bool
  default     = false
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault"
  type        = bool
  default     = false
}

variable "key_vault_purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault?"
  type        = bool
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted"
  type        = number
  default     = 90
  validation {
    condition     = var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

variable "key_vault_public_network_access_enabled" {
  description = "Whether public network access is allowed for this Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_network_acls_bypass" {
  description = "Specifies which traffic can bypass the network rules"
  type        = string
  default     = "AzureServices"
  validation {
    condition     = contains(["AzureServices", "None"], var.key_vault_network_acls_bypass)
    error_message = "Network ACLs bypass must be either 'AzureServices' or 'None'."
  }
}

variable "key_vault_network_acls_default_action" {
  description = "The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids"
  type        = string
  default     = "Deny"
  validation {
    condition     = contains(["Allow", "Deny"], var.key_vault_network_acls_default_action)
    error_message = "Network ACLs default action must be either 'Allow' or 'Deny'."
  }
}

variable "key_vault_network_acls_ip_rules" {
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "key_vault_network_acls_subnet_ids" {
  description = "One or more Subnet IDs which should be able to access this Key Vault"
  type        = list(string)
  default     = []
}

# Private Endpoint Variables

variable "enable_key_vault_private_endpoint" {
  description = "Enable private endpoint for Key Vault"
  type        = bool
  default     = true
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "vnet-main"
  validation {
    condition     = length(var.vnet_name) >= 2 && length(var.vnet_name) <= 64
    error_message = "Virtual Network name must be between 2 and 64 characters."
  }
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "At least one address space must be provided for the Virtual Network."
  }
}

variable "private_endpoint_subnet_name" {
  description = "Name of the subnet for private endpoints"
  type        = string
  default     = "subnet-private-endpoints"
  validation {
    condition     = length(var.private_endpoint_subnet_name) >= 1 && length(var.private_endpoint_subnet_name) <= 80
    error_message = "Subnet name must be between 1 and 80 characters."
  }
}

variable "private_endpoint_subnet_address_prefixes" {
  description = "Address prefixes for the private endpoint subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
  validation {
    condition     = length(var.private_endpoint_subnet_address_prefixes) > 0
    error_message = "At least one address prefix must be provided for the subnet."
  }
}

variable "key_vault_private_endpoint_name" {
  description = "Name of the Key Vault private endpoint"
  type        = string
  default     = "pe-keyvault"
  validation {
    condition     = length(var.key_vault_private_endpoint_name) >= 1 && length(var.key_vault_private_endpoint_name) <= 80
    error_message = "Private endpoint name must be between 1 and 80 characters."
  }
}

variable "private_endpoint_nsg_name" {
  description = "Name of the Network Security Group for private endpoints"
  type        = string
  default     = "nsg-private-endpoints"
  validation {
    condition     = length(var.private_endpoint_nsg_name) >= 1 && length(var.private_endpoint_nsg_name) <= 80
    error_message = "NSG name must be between 1 and 80 characters."
  }
}

# Function App Variables

variable "function_app_name" {
  description = "Name of the Azure Function App"
  type        = string
  validation {
    condition     = length(var.function_app_name) >= 2 && length(var.function_app_name) <= 60 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.function_app_name))
    error_message = "Function App name must be between 2-60 characters, start and end with alphanumeric characters, and contain only alphanumeric characters and hyphens."
  }
}

variable "function_app_service_plan_name" {
  description = "Name of the App Service Plan for the Function App"
  type        = string
  default     = "asp-functions"
  validation {
    condition     = length(var.function_app_service_plan_name) >= 1 && length(var.function_app_service_plan_name) <= 40
    error_message = "App Service Plan name must be between 1 and 40 characters."
  }
}

variable "function_app_os_type" {
  description = "Operating system type for the Function App"
  type        = string
  default     = "Linux"
  validation {
    condition     = contains(["Linux", "Windows"], var.function_app_os_type)
    error_message = "OS type must be either 'Linux' or 'Windows'."
  }
}

variable "function_app_sku_name" {
  description = "SKU name for the App Service Plan"
  type        = string
  default     = "Y1"
  validation {
    condition = contains([
      "Y1", "EP1", "EP2", "EP3", "P1", "P2", "P3", "P1v2", "P2v2", "P3v2", "P1v3", "P2v3", "P3v3",
      "S1", "S2", "S3", "B1", "B2", "B3"
    ], var.function_app_sku_name)
    error_message = "SKU name must be a valid App Service Plan SKU."
  }
}

variable "function_app_runtime" {
  description = "Runtime stack for the Function App"
  type        = string
  default     = "dotnet"
  validation {
    condition     = contains(["dotnet", "node", "python", "java", "powershell"], var.function_app_runtime)
    error_message = "Runtime must be one of: dotnet, node, python, java, powershell."
  }
}

variable "function_app_dotnet_version" {
  description = ".NET version for Function App"
  type        = string
  default     = "6.0"
  validation {
    condition     = contains(["3.1", "6.0", "7.0", "8.0"], var.function_app_dotnet_version)
    error_message = ".NET version must be one of: 3.1, 6.0, 7.0, 8.0."
  }
}

variable "function_app_node_version" {
  description = "Node.js version for Function App"
  type        = string
  default     = "18"
  validation {
    condition     = contains(["14", "16", "18", "20"], var.function_app_node_version)
    error_message = "Node.js version must be one of: 14, 16, 18, 20."
  }
}

variable "function_app_python_version" {
  description = "Python version for Function App"
  type        = string
  default     = "3.9"
  validation {
    condition     = contains(["3.7", "3.8", "3.9", "3.10", "3.11"], var.function_app_python_version)
    error_message = "Python version must be one of: 3.7, 3.8, 3.9, 3.10, 3.11."
  }
}

variable "function_app_powershell_version" {
  description = "PowerShell version for Function App"
  type        = string
  default     = "7.2"
  validation {
    condition     = contains(["7.0", "7.2"], var.function_app_powershell_version)
    error_message = "PowerShell version must be one of: 7.0, 7.2."
  }
}

variable "function_app_public_network_access_enabled" {
  description = "Whether public network access is enabled for the Function App"
  type        = bool
  default     = true
}

variable "function_app_settings" {
  description = "Custom application settings for the Function App"
  type        = map(string)
  default     = {}
}

variable "function_app_cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "function_app_cors_support_credentials" {
  description = "Whether CORS should support credentials"
  type        = bool
  default     = false
}

# Storage Account Variables for Function App

variable "function_app_storage_account_name" {
  description = "Name of the storage account for the Function App"
  type        = string
  validation {
    condition     = length(var.function_app_storage_account_name) >= 3 && length(var.function_app_storage_account_name) <= 24 && can(regex("^[a-z0-9]+$", var.function_app_storage_account_name))
    error_message = "Storage account name must be between 3-24 characters and contain only lowercase letters and numbers."
  }
}

variable "function_app_storage_account_tier" {
  description = "Performance tier of the storage account"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.function_app_storage_account_tier)
    error_message = "Storage account tier must be either 'Standard' or 'Premium'."
  }
}

variable "function_app_storage_account_replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.function_app_storage_account_replication_type)
    error_message = "Replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "function_app_storage_public_access_enabled" {
  description = "Whether public access is enabled for the Function App storage account"
  type        = bool
  default     = false
}

variable "function_app_storage_default_action" {
  description = "Default action for storage account network rules"
  type        = string
  default     = "Allow"
  validation {
    condition     = contains(["Allow", "Deny"], var.function_app_storage_default_action)
    error_message = "Storage default action must be either 'Allow' or 'Deny'."
  }
}

variable "function_app_storage_ip_rules" {
  description = "List of IP addresses or CIDR blocks that should be allowed to access the storage account"
  type        = list(string)
  default     = []
}

variable "function_app_storage_subnet_ids" {
  description = "List of subnet IDs that should be allowed to access the storage account"
  type        = list(string)
  default     = []
}

# Application Insights Variables

variable "enable_application_insights" {
  description = "Whether to enable Application Insights for the Function App"
  type        = bool
  default     = true
}

variable "application_insights_name" {
  description = "Name of the Application Insights resource"
  type        = string
  default     = "appi-functions"
  validation {
    condition     = length(var.application_insights_name) >= 1 && length(var.application_insights_name) <= 260
    error_message = "Application Insights name must be between 1 and 260 characters."
  }
}

variable "grant_function_app_key_vault_access" {
  description = "Whether to grant the Function App access to the Key Vault"
  type        = bool
  default     = true
}

# Storage Account Private Endpoint Variables

variable "enable_storage_private_endpoint" {
  description = "Enable private endpoints for storage account"
  type        = bool
  default     = true
}

variable "storage_blob_private_endpoint_name" {
  description = "Name of the storage blob private endpoint"
  type        = string
  default     = "pe-storage-blob"
  validation {
    condition     = length(var.storage_blob_private_endpoint_name) >= 1 && length(var.storage_blob_private_endpoint_name) <= 80
    error_message = "Storage blob private endpoint name must be between 1 and 80 characters."
  }
}

variable "storage_queue_private_endpoint_name" {
  description = "Name of the storage queue private endpoint"
  type        = string
  default     = "pe-storage-queue"
  validation {
    condition     = length(var.storage_queue_private_endpoint_name) >= 1 && length(var.storage_queue_private_endpoint_name) <= 80
    error_message = "Storage queue private endpoint name must be between 1 and 80 characters."
  }
}

variable "storage_table_private_endpoint_name" {
  description = "Name of the storage table private endpoint"
  type        = string
  default     = "pe-storage-table"
  validation {
    condition     = length(var.storage_table_private_endpoint_name) >= 1 && length(var.storage_table_private_endpoint_name) <= 80
    error_message = "Storage table private endpoint name must be between 1 and 80 characters."
  }
}

variable "storage_file_private_endpoint_name" {
  description = "Name of the storage file private endpoint"
  type        = string
  default     = "pe-storage-file"
  validation {
    condition     = length(var.storage_file_private_endpoint_name) >= 1 && length(var.storage_file_private_endpoint_name) <= 80
    error_message = "Storage file private endpoint name must be between 1 and 80 characters."
  }
}