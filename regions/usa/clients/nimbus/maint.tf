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
  name                = "log-management-prod"
  resource_group_name = "rg-management-prod"
}

data "azurerm_databricks_workspace" "this" {
  provider            = azurerm.management
  name                = "dbx-southcentralus-prod"
  resource_group_name = "rg-management-prod"
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

  depends_on = [
    module.storage,
    module.unity_catalog
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