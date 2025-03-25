# Module_blocks in root

module "network" {
  source                  = "./modules/network"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_id       = azurerm_resource_group.main.id
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  trusted_ip_ranges       = var.trusted_ip_ranges
  region                  = var.region
  client                  = var.client
  suffix                  = var.suffix
  default_tags            = local.default_tags
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  region              = var.region
  vnet_id             = module.network.vnet_id
  vnet_name           = module.network.vnet_name
  subnet_id           = module.network.subnet_id
  client              = var.client
  suffix              = var.suffix
  default_tags        = local.default_tags
  log_analytics_id    = module.monitoring.log_analytics_id
  adls_logs           = var.adls_logs

  depends_on = [module.network]
}

module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  region              = var.region
  client              = var.client
  suffix              = var.suffix
  alert_email         = var.alert_email
  default_tags        = local.default_tags
}

module "databricks_workspace" {
  source                  = "./modules/databricks_workspace"
  client                  = var.client
  resource_group_name     = azurerm_resource_group.main.name
  region                  = var.region
  suffix                  = var.suffix
  default_tags            = local.default_tags
  subnet_address_prefixes = var.subnet_address_prefixes
  vnet_id                 = module.network.vnet_id
  vnet_name               = module.network.vnet_name
  subnet_id               = module.network.subnet_id
  public_ip_id            = module.network.public_ip_id
  nat_gateway_id          = module.network.nat_gateway_id
  log_analytics_id        = module.monitoring.log_analytics_id
  dbx_logs                = var.dbx_logs

  depends_on = [
    module.storage,
    module.monitoring
  ]
}

module "security" {
  source              = "./modules/security"
  client              = var.client
  suffix              = var.suffix
  region              = var.region
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  default_tags        = local.default_tags
  workspace_id        = module.databricks_workspace.workspace_id
  datalake_id         = module.storage.datalake_id
  workspace_url       = module.databricks_workspace.workspace_url
  account_id          = var.account_id

  depends_on = [
    module.databricks_workspace,
    module.storage
  ]
}

module "unity_catalog" {
  source = "./modules/unity_catalog"
  providers = {
    databricks.workspace_resources = databricks.workspace_resources
  }

  client              = var.client
  suffix              = var.suffix
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  region              = var.region
  secondary_region    = var.secondary_region
  datalake_name       = module.storage.datalake_name
  datalake_id         = module.storage.datalake_id
  workspace_id        = module.databricks_workspace.workspace_id
  metastore_id        = var.metastore_id

  depends_on = [
    module.security,
    module.storage,
    module.databricks_workspace
  ]
}

module "compute" {
  source = "./modules/compute"
  providers = {
    azapi = azapi
  }
  client              = var.client
  suffix              = var.suffix
  region              = var.region
  username            = var.username
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  vnet_id             = module.network.vnet_id
  vnet_name           = module.network.vnet_name
  subnet_id           = module.network.subnet_id
  public_subnet_id    = module.network.public_subnet_id
  default_tags        = local.default_tags

  depends_on = [
    module.security,
    module.storage,
    module.databricks_workspace,
    module.unity_catalog
  ]
}

