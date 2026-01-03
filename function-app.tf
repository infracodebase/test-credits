# Azure Function App configuration

# Storage Account for Function App (required)
resource "azurerm_storage_account" "function_app" {
  name                     = var.function_app_storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.function_app_storage_account_tier
  account_replication_type = var.function_app_storage_account_replication_type

  # Security settings
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = var.function_app_storage_public_access_enabled
  allow_nested_items_to_be_public = false

  # Network rules
  network_rules {
    default_action             = var.enable_storage_private_endpoint ? "Deny" : var.function_app_storage_default_action
    ip_rules                   = var.function_app_storage_ip_rules
    virtual_network_subnet_ids = concat(
      var.function_app_storage_subnet_ids,
      var.enable_storage_private_endpoint ? [azurerm_subnet.private_endpoint.id] : []
    )
    bypass = ["AzureServices"]
  }

  tags = var.tags
}

# App Service Plan for Function App
resource "azurerm_service_plan" "function_app" {
  name                = var.function_app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = var.function_app_os_type
  sku_name            = var.function_app_sku_name

  tags = var.tags
}

# Function App
resource "azurerm_linux_function_app" "main" {
  count                      = var.function_app_os_type == "Linux" ? 1 : 0
  name                       = var.function_app_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  service_plan_id           = azurerm_service_plan.function_app.id
  storage_account_name      = azurerm_storage_account.function_app.name
  storage_account_access_key = azurerm_storage_account.function_app.primary_access_key

  # Security and networking
  https_only                    = true
  public_network_access_enabled = var.function_app_public_network_access_enabled

  # Application settings
  app_settings = merge(
    var.function_app_settings,
    {
      "FUNCTIONS_WORKER_RUNTIME"     = var.function_app_runtime
      "WEBSITE_RUN_FROM_PACKAGE"     = "1"
      "APPINSIGHTS_INSTRUMENTATIONKEY" = var.enable_application_insights ? azurerm_application_insights.function_app[0].instrumentation_key : null
    }
  )

  site_config {
    minimum_tls_version = "1.2"

    application_stack {
      dynamic "dotnet" {
        for_each = var.function_app_runtime == "dotnet" ? [1] : []
        content {
          dotnet_version = var.function_app_dotnet_version
        }
      }

      dynamic "node" {
        for_each = var.function_app_runtime == "node" ? [1] : []
        content {
          node_version = var.function_app_node_version
        }
      }

      dynamic "python" {
        for_each = var.function_app_runtime == "python" ? [1] : []
        content {
          python_version = var.function_app_python_version
        }
      }
    }

    # CORS settings
    cors {
      allowed_origins     = var.function_app_cors_allowed_origins
      support_credentials = var.function_app_cors_support_credentials
    }
  }

  # Identity configuration
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Windows Function App (alternative to Linux)
resource "azurerm_windows_function_app" "main" {
  count                      = var.function_app_os_type == "Windows" ? 1 : 0
  name                       = var.function_app_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  service_plan_id           = azurerm_service_plan.function_app.id
  storage_account_name      = azurerm_storage_account.function_app.name
  storage_account_access_key = azurerm_storage_account.function_app.primary_access_key

  # Security and networking
  https_only                    = true
  public_network_access_enabled = var.function_app_public_network_access_enabled

  # Application settings
  app_settings = merge(
    var.function_app_settings,
    {
      "FUNCTIONS_WORKER_RUNTIME"     = var.function_app_runtime
      "WEBSITE_RUN_FROM_PACKAGE"     = "1"
      "APPINSIGHTS_INSTRUMENTATIONKEY" = var.enable_application_insights ? azurerm_application_insights.function_app[0].instrumentation_key : null
    }
  )

  site_config {
    minimum_tls_version = "1.2"

    application_stack {
      dotnet_version = var.function_app_runtime == "dotnet" ? var.function_app_dotnet_version : null
      node_version   = var.function_app_runtime == "node" ? var.function_app_node_version : null
      powershell_core_version = var.function_app_runtime == "powershell" ? var.function_app_powershell_version : null
    }

    # CORS settings
    cors {
      allowed_origins     = var.function_app_cors_allowed_origins
      support_credentials = var.function_app_cors_support_credentials
    }
  }

  # Identity configuration
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Application Insights for Function App monitoring
resource "azurerm_application_insights" "function_app" {
  count               = var.enable_application_insights ? 1 : 0
  name                = var.application_insights_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"

  tags = var.tags
}

# Grant Function App access to Key Vault
resource "azurerm_key_vault_access_policy" "function_app" {
  count        = var.grant_function_app_key_vault_access ? 1 : 0
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.function_app_os_type == "Linux" ? azurerm_linux_function_app.main[0].identity[0].principal_id : azurerm_windows_function_app.main[0].identity[0].principal_id

  secret_permissions = [
    "Get",
    "List",
  ]

  key_permissions = [
    "Get",
    "List",
  ]
}