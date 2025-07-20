


# Creates a Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.client}-${var.region}-${var.environment}"
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

module "network" {
  source                  = "../../../modules/network"
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

module "dbx_workspace" {
  source                  = "../../../modules/dbx_workspace"
  client                  = var.client
  resource_group_name     = azurerm_resource_group.main.name
  region                  = var.region
  environment             = var.environment
  default_tags            = local.default_tags
  subnet_address_prefixes = var.subnet_address_prefixes
  vnet_id                 = module.network.vnet_id
  vnet_name               = module.network.vnet_name
  subnet_id               = module.network.subnet_id
  public_ip_id            = module.network.public_ip_id
  nat_gateway_id          = module.network.nat_gateway_id
  log_analytics_id        = data.azurerm_log_analytics_workspace.main.id
  dbx_logs                = var.dbx_logs
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
