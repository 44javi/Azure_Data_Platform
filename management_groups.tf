# Root module management_groups
data "azurerm_client_config" "current" {}

# Create Management Groups
resource "azurerm_management_group" "cyber_nimbus" {
  display_name                = "Cyber Nimbus"
  parent_management_group_id   = var.root_management_group_id
}

# Create Management Groups
resource "azurerm_management_group" "Sandbox" {
  display_name                = "Sandbox"
  parent_management_group_id   = azurerm_management_group.cyber_nimbus.id
}

# Create Management Groups
resource "azurerm_management_group" "Platform" {
  display_name                = "Platform"
  parent_management_group_id   = azurerm_management_group.cyber_nimbus.id
}

# Create Management Groups
resource "azurerm_management_group" "Management" {
  display_name                = "Management"
  parent_management_group_id   = azurerm_management_group.Platform.id
}

# Create Management Groups
resource "azurerm_management_group" "regions" {
  display_name                = "Regions"
  parent_management_group_id   = azurerm_management_group.cyber_nimbus.id
}

# Create Management Groups for each country
resource "azurerm_management_group" "countries" {
  for_each                    = toset(var.countries)
  display_name                = each.value
  parent_management_group_id   = azurerm_management_group.regions.id
}

