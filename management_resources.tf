# Root module management_resources

data "azurerm_client_config" "current" {}


# Define the list of continents (Management Groups)
variable "continents" {
  type    = list(string)
  default = ["NorthAmerica", "Europe", "Asia", "SouthAmerica", "Africa", "Australia"]
}

# Create Management Groups for each continent
resource "azurerm_management_group" "continents" {
  for_each                    = toset(var.continents)
  display_name                = each.value
  parent_management_group_id   = var.root_management_group_id
}


# Create a Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.client}_Data_Platform_${var.suffix}"
  location = var.region
}
# Creates a Key Vault for secret management
resource "azurerm_key_vault" "this" {
  name                       = "${var.client}keyvault${var.suffix}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.region
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 30
  purge_protection_enabled   = true

  tags = local.default_tags
}

# for tags
locals {
  default_tags = {
    owner       = var.owner
    environment = var.environment
    project     = var.project
    client      = var.client
    region      = var.region
    created_by  = "Terraform"
  }
}
