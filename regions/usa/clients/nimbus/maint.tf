# Creates a Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.client}-${var.environment}"
  location = var.region
}

data "azuread_group" "data_engineers" {
  display_name = "Data_Engineers"
}

data "azurerm_log_analytics_workspace" "main" {
  provider            = azurerm.monitoring
  name                = "log-platform-prod"
  resource_group_name = "rg-platform-prod"
}

data "azurerm_databricks_workspace" "this" {
  provider            = azurerm.management
  name                = "dbx-southcentralus-prod"
  resource_group_name = "rg-management-prod"
}

data "azurerm_virtual_network" "management" {
  provider            = azurerm.management
  name                = "vnet-management-prod"
  resource_group_name = "rg-management-prod"
}

# Management to Client peering
resource "azurerm_virtual_network_peering" "management_to_client" {
  provider                     = azurerm.management
  name                         = "peer-management-to-${var.client}"
  resource_group_name          = "rg-management-prod"
  virtual_network_name         = "vnet-management-prod"
  remote_virtual_network_id    = module.network.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on                   = [module.network]
}

# Client to Management peering  
resource "azurerm_virtual_network_peering" "client_to_management" {
  name                         = "peer-${var.client}-to-management"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = module.network.vnet_name
  remote_virtual_network_id    = data.azurerm_virtual_network.management.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on                   = [module.network]
}

module "network" {
  source                  = "../../../../modules/network"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_id       = azurerm_resource_group.main.id
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  trusted_ip_ranges       = var.trusted_ip_ranges
  region                  = var.region
  client                  = var.client
  environment             = var.environment
  default_tags            = local.default_tags
}

module "storage" {
  source              = "../../../../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  region              = var.region
  vnet_id             = module.network.vnet_id
  vnet_name           = module.network.vnet_name
  subnet_id           = module.network.subnet_id
  client              = var.client
  environment         = var.environment
  containers          = var.containers
  default_tags        = local.default_tags
  log_analytics_id    = data.azurerm_log_analytics_workspace.main.id
  adls_logs           = var.adls_logs

  depends_on = [
    module.network
  ]
}

module "security" {
  source              = "../../../../modules/security"
  client              = var.client
  environment         = var.environment
  region              = var.region
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  default_tags        = local.default_tags

  depends_on = [
    module.storage
  ]
}

module "unity_catalog" {
  source = "../../../../modules/unity_catalog"
  providers = {
    databricks.workspace_resources = databricks.workspace_resources
  }

  client              = var.client
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  region              = var.region
  datalake_name       = module.storage.datalake_name
  datalake_id         = module.storage.datalake_id
  containers          = var.containers
  schemas             = var.schemas
  workspace_id        = data.azurerm_databricks_workspace.this.workspace_id

  depends_on = [
    module.storage,
  ]
}

module "compute" {
  source = "../../../../modules/compute"
  providers = {
    azapi = azapi
  }
  client              = var.client
  environment         = var.environment
  region              = var.region
  username            = var.username
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  vnet_id             = module.network.vnet_id
  vnet_name           = module.network.vnet_name
  subnet_id           = module.network.subnet_id
  public_subnet_id    = module.network.public_subnet_id
  default_tags        = local.default_tags
  vm_private_ip       = var.vm_private_ip
  key_vault_id        = module.security.key_vault_id
  log_analytics_id    = data.azurerm_log_analytics_workspace.main.id
  log_location        = data.azurerm_log_analytics_workspace.main.location

  depends_on = [
    module.storage,
    module.unity_catalog,
    module.security
  ]
}

# Optional for when an application outside of Azure needs permissions to the datalake
module "service_principal" {
  source              = "../../../../modules/service_principal"
  client              = var.client
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  key_vault_id        = module.security.key_vault_id
   datalake_id         = module.storage.datalake_id

  depends_on = [
    module.security,
    module.storage
  ]
}

# for tags
locals {
  default_tags = {
    owner       = var.owner
    environment = var.environment
    client      = var.client
    region      = var.region
    created_by  = "Terraform"
  }
}
