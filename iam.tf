# Create Data Engineers Security Group
resource "azuread_group" "data_engineers" {
  display_name     = "Data_Engineers"
  security_enabled = true
  description      = "Group for data related access"
}

# Create External Security Group
resource "azuread_group" "External_Users" {
  display_name     = "External_Users"
  security_enabled = true
  description      = "Group for guests to have access to Azure resources"
}




# For Azure Backend set up

# Creates a Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.client}-${var.region}-${var.environment}"
  location = var.region
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

