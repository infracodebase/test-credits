# Configure the Azure Provider
terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  # Common feature configurations for production environments
  features {
    # Key Vault features
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }

    # Resource Group features
    resource_group {
      prevent_deletion_if_contains_resources = true
    }

    # Virtual Machine features
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown             = false
      skip_shutdown_and_force_delete = false
    }

    # Virtual Machine Scale Set features
    virtual_machine_scale_set {
      roll_instances_when_required = true
    }

    # Log Analytics Workspace features
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }

    # Application Insights features
    application_insights {
      disable_generated_rule = false
    }
  }

  # Optional: Specify subscription ID explicitly
  # subscription_id = var.subscription_id

  # Optional: Specify tenant ID explicitly
  # tenant_id = var.tenant_id

  # Optional: Use specific client credentials
  # client_id     = var.client_id
  # client_secret = var.client_secret

  # Optional: Skip provider registration for faster execution
  # skip_provider_registration = true

  # Optional: Configure storage use for enhanced security
  # storage_use_azuread = true
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}