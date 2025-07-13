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