# Azure Quota Requirements

> **Verify your subscription has sufficient quota BEFORE the microhack.**

## Per-Team Resource Requirements

Each team will deploy infrastructure for the FreshConnect platform. The following quotas
are required **per team**:

| Resource Type                  | Quantity | SKU/Tier                   | Region              |
| ------------------------------ | -------- | -------------------------- | ------------------- |
| Resource Groups                | 1-2      | N/A                        | Sweden Central      |
| App Service Plans              | 1        | P1v4 or S1                 | Sweden Central      |
| App Services (Web Apps)        | 1-2      | N/A                        | Sweden Central      |
| Azure SQL Server               | 1        | N/A                        | Sweden Central      |
| Azure SQL Database             | 1        | S0 or Basic                | Sweden Central      |
| Storage Accounts               | 1-2      | Standard_LRS               | Sweden Central      |
| Key Vault                      | 1        | Standard                   | Sweden Central      |
| Application Insights           | 1        | N/A                        | Sweden Central      |
| Log Analytics Workspace        | 1        | Per-GB                     | Sweden Central      |

### Optional Advanced Resources

Depending on architectural decisions, teams may also deploy these resources. Ensure your
subscription allows creation of:

| Resource Type                  | Quantity | SKU/Tier                   | Region              |
| ------------------------------ | -------- | -------------------------- | ------------------- |
| Azure Front Door               | 1        | Standard or Premium        | Global              |
| Application Gateway            | 1        | Standard_v2 or WAF_v2      | Sweden Central      |
| Web Application Firewall (WAF) | 1        | N/A (part of AppGW/AFD)    | Sweden Central      |
| Traffic Manager                | 1        | N/A                        | Global              |
| Azure Container Registry       | 1        | Basic or Standard          | Sweden Central      |

> 💡 Teams may choose different architectures. Verify you can deploy these resource types
> even if you don't plan to use all of them.

### Challenge 4: HA/DR Additional Resources

Teams completing the disaster recovery challenge will deploy additional resources:

| Resource Type                  | Quantity | SKU/Tier                   | Region                |
| ------------------------------ | -------- | -------------------------- | --------------------- |
| Resource Groups                | 1        | N/A                        | Germany West Central  |
| App Service Plans              | 1        | P1v4 or S1                 | Germany West Central  |
| App Services (Web Apps)        | 1        | N/A                        | Germany West Central  |
| Azure SQL Database (replica)   | 1        | S0 or Basic                | Germany West Central  |
| Storage Accounts (GRS)         | 1        | Standard_GRS               | Sweden Central        |

## Multi-Team Shared Subscription

If multiple teams share a single Azure subscription, multiply the requirements accordingly.

**Example: 4 teams sharing one subscription**

| Resource Type                  | Total Quantity |
| ------------------------------ | -------------- |
| Resource Groups                | 8-12           |
| App Service Plans              | 8              |
| App Services (Web Apps)        | 8-12           |
| Azure SQL Servers              | 4              |
| Azure SQL Databases            | 8              |
| Storage Accounts               | 8-12           |
| Key Vaults                     | 4              |
| Application Insights           | 4              |
| Log Analytics Workspaces       | 4              |

## How to Check Your Quotas

### Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for "Quotas" in the top search bar
3. Select "Quotas" under Services
4. Filter by region (Sweden Central, Germany West Central)
5. Review quotas for each resource type

### Azure CLI

```bash
# Check compute quotas for a region
az vm list-usage --location swedencentral --output table

# Check storage account count
az storage account list --query "length(@)"

# Check SQL database quotas (requires existing server)
az sql db list-usage --server <server-name> --resource-group <rg-name>
```

## Common Quota Issues

| Issue                           | Solution                                               |
| ------------------------------- | ------------------------------------------------------ |
| "Subscription not registered"   | Register provider: `az provider register --namespace Microsoft.Web` |
| "Quota exceeded"                | Request quota increase via Azure Portal → Quotas       |
| "Region not available"          | Use alternative region or request access               |
| "SKU not available in region"   | Try different SKU tier                                 |

## Requesting Quota Increases

If you need to increase quotas:

1. Go to [Azure Portal → Quotas](https://portal.azure.com/#view/Microsoft_Azure_Capacity/QuotaMenuBlade/~/overview)
2. Select the resource type
3. Click "Request increase"
4. Provide justification (e.g., "Microhack event with 4 teams")
5. Allow 24-48 hours for approval

> ⚠️ **Request quota increases at least 1 week before the microhack** to ensure approval.

## Estimated Costs

Approximate costs for a 6-hour microhack (resources running for ~8 hours including setup/cleanup):

| Configuration          | Estimated Cost |
| ---------------------- | -------------- |
| Single team (basic)    | €5-10          |
| Single team (with DR)  | €10-20         |
| 4 teams (shared sub)   | €30-50         |

> 💡 **Tip**: Delete all resources immediately after the microhack to minimize costs.
> Use the cleanup script: `scripts/microhack/Cleanup-MicrohackResources.ps1`

## Pre-Microhack Verification

Run this verification before the event:

```powershell
# Login to Azure
az login

# Set your subscription
az account set --subscription "<your-subscription-id>"

# Verify you can create a resource group in Sweden Central
az group create --name rg-quota-test --location swedencentral

# Clean up test resource group
az group delete --name rg-quota-test --yes --no-wait
```

If this succeeds, your subscription is ready for the microhack.
