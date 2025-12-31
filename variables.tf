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