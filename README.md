# Azure Infrastructure with Terraform. v2

A comprehensive Terraform configuration for deploying Azure infrastructure including Resource Group, Key Vault, Function App, Virtual Network, and Private Endpoints for secure connectivity.

## Architecture Overview

This infrastructure deploys:

- **Azure Resource Group** - Container for all resources
- **Azure Key Vault** - Secure secrets management with private endpoint
- **Azure Function App** - Serverless compute with Linux/Windows support
- **Virtual Network** - Private networking with dedicated subnet for private endpoints
- **Storage Account** - Function App storage with comprehensive private endpoints (blob, queue, table, file)
- **Application Insights** - Monitoring and telemetry
- **Private Endpoints** - Secure private connectivity for Key Vault and Storage
- **Network Security Group** - Traffic control for private endpoints

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.6
- Azure CLI installed and authenticated
- Azure subscription with appropriate permissions

## Required Azure Credentials

Set these environment variables or configure them as workspace secrets:

```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

## Quick Start

1. **Clone and configure**:
   ```bash
   git clone <repository-url>
   cd <repository-name>
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Customize variables**:
   Edit `terraform.tfvars` with your specific configuration:
   ```hcl
   resource_group_name = "rg-myproject-dev-001"
   location           = "East US"
   key_vault_name     = "kv-myproject-dev-001"
   function_app_name  = "func-myproject-dev-001"
   ```

3. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration

### Core Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `resource_group_name` | Name of the Azure resource group | - | Yes |
| `location` | Azure region for resources | `"East US"` | No |
| `key_vault_name` | Name of the Key Vault | - | Yes |
| `function_app_name` | Name of the Function App | - | Yes |

### Key Vault Configuration

- **Security**: Private endpoint enabled, public access disabled by default
- **Purge Protection**: Enabled for production safety
- **Soft Delete**: 90-day retention period
- **Access Policy**: Automatic policy for current client with full permissions
- **Function App Integration**: Automatic access policy for Function App managed identity

### Function App Configuration

- **Runtime Options**: .NET, Node.js, Python, PowerShell support
- **Hosting**: Linux (default) or Windows
- **Plan**: Consumption (Y1) default, configurable to Premium/Dedicated
- **Security**: HTTPS only, system-assigned managed identity
- **Monitoring**: Application Insights integration
- **Storage**: Dedicated storage account with private endpoints

### Network Configuration

- **Virtual Network**: 10.0.0.0/16 default address space
- **Private Endpoint Subnet**: 10.0.1.0/24 for all private endpoints
- **DNS Integration**: Private DNS zones for Key Vault and Storage services
- **Security**: Network Security Group with restrictive HTTPS-only rules

### Private Endpoints

#### Key Vault Private Endpoint
- Service: `vault`
- DNS Zone: `privatelink.vaultcore.azure.net`

#### Storage Private Endpoints
- **Blob**: `privatelink.blob.core.windows.net`
- **Queue**: `privatelink.queue.core.windows.net`
- **Table**: `privatelink.table.core.windows.net`
- **File**: `privatelink.file.core.windows.net`

## File Structure

```
.
├── main.tf                     # Provider configuration and resource group
├── keyvault.tf                 # Key Vault configuration
├── function-app.tf             # Function App, App Service Plan, Storage Account
├── private-endpoint.tf         # Virtual Network, Private Endpoints, DNS zones
├── variables.tf                # Variable definitions
├── outputs.tf                  # Output values
├── terraform.tfvars.example    # Example variable configuration
├── .gitignore                  # Terraform-specific gitignore
└── README.md                   # This file
```

## Examples

### Basic Deployment
```hcl
resource_group_name = "rg-webapp-prod-001"
location           = "West Europe"
key_vault_name     = "kv-webapp-prod-001"
function_app_name  = "func-webapp-prod-001"
```

### Advanced Configuration
```hcl
# Function App with specific runtime
function_app_runtime        = "node"
function_app_node_version   = "20"
function_app_sku_name      = "EP1"  # Premium plan

# Custom networking
vnet_address_space                    = ["172.16.0.0/16"]
private_endpoint_subnet_address_prefixes = ["172.16.1.0/24"]

# Enhanced security
key_vault_public_network_access_enabled = false
function_app_storage_default_action     = "Deny"
```

## Outputs

The module provides comprehensive outputs for integration:

- **Resource identifiers**: IDs for all created resources
- **Network information**: VNet, subnet, and private endpoint details
- **Function App details**: Hostname, identity principal ID
- **Key Vault information**: URI, tenant ID, access details

## Security Features

- **Private Connectivity**: All storage and Key Vault traffic uses private endpoints
- **Network Isolation**: Resources deployed in dedicated Virtual Network
- **Access Control**: Managed identities and access policies
- **Encryption**: TLS 1.2 minimum, encrypted storage
- **Compliance**: Purge protection and soft delete for Key Vault

## Monitoring

- **Application Insights**: Automatic Function App monitoring
- **Metrics**: All Azure resources provide standard metrics
- **Logs**: Centralized logging through Application Insights

## Cost Optimization

- **Consumption Plan**: Default Y1 plan for cost-effective serverless compute
- **Standard Storage**: LRS replication for development environments
- **Resource Tagging**: Comprehensive tagging for cost tracking

## Contributing

1. Follow Terraform best practices
2. Update documentation for any new variables
3. Test configurations in development environment
4. Add appropriate variable validation

## Troubleshooting

### Common Issues

**Private Endpoint DNS Resolution**:
- Ensure DNS zones are linked to Virtual Network
- Verify private endpoint subnet configuration

**Function App Storage Access**:
- Check storage account network rules
- Verify private endpoint connectivity

**Key Vault Access**:
- Confirm access policies are properly configured
- Validate network ACL settings

## Clean Up

To destroy the infrastructure:

```bash
terraform destroy
```

**Note**: Key Vault has purge protection enabled. After destruction, you may need to purge the Key Vault manually if recreating with the same name.

## License

This project is licensed under the MIT License - see the LICENSE file for details.