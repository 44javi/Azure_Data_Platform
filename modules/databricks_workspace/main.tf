# /modules/databricks_workspace/main.tf

# Azure Databricks Workspace with VNet injection
resource "azurerm_databricks_workspace" "this" {
  name                        = "dbx-workspace-${var.client}-${var.suffix}"
  resource_group_name         = var.resource_group_name
  location                    = var.region
  sku                         = "premium"                                 # Chose premium for job clusters and private endpoint, Role-Based Access Control (RBAC), Audit Logs, and Cluster Policies.
  managed_resource_group_name = "clusters-rg-${var.client}-${var.suffix}" # Databricks creates a mandatory managed RG

  tags = var.default_tags

  #public_network_access_enabled = false  

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = azurerm_subnet.databricks_public_subnet.name
    private_subnet_name                                  = azurerm_subnet.databricks_private_subnet.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.nsg_assoc_public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.nsg_assoc_private.id
  }
}

# Public Subnet for Databricks
resource "azurerm_subnet" "databricks_public_subnet" {
  name                 = "dbx-public-subnet-${var.client}-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_address_prefixes["databricks_public_subnet"]]

  # Disable default outbound access
  default_outbound_access_enabled = false

  delegation {
    name = "databricks_delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Private or Container Subnet for Databricks 
resource "azurerm_subnet" "databricks_private_subnet" {
  name                 = "dbx-private-subnet-${var.client}-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_address_prefixes["databricks_private_subnet"]]

  # Disable default outbound access
  default_outbound_access_enabled = false

  delegation {
    name = "databricks_delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}



# NSG for Public Subnet nsg
resource "azurerm_network_security_group" "databricks_public_nsg" {
  name                = "dbx-public-nsg-${var.client}-${var.suffix}"
  location            = var.region
  resource_group_name = var.resource_group_name

}


# NSG for Private Subnet
resource "azurerm_network_security_group" "databricks_private_nsg" {
  name                = "dbx-private-nsg-${var.client}-${var.suffix}"
  location            = var.region
  resource_group_name = var.resource_group_name

}

# NSG association for Public Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_public" {
  subnet_id                 = azurerm_subnet.databricks_public_subnet.id
  network_security_group_id = azurerm_network_security_group.databricks_public_nsg.id
}


# NSG association for Private Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_private" {
  subnet_id                 = azurerm_subnet.databricks_private_subnet.id
  network_security_group_id = azurerm_network_security_group.databricks_private_nsg.id
}


# Associate the NAT Gateway with the Databricks Public Subnet
resource "azurerm_subnet_nat_gateway_association" "databricks_public" {
  subnet_id      = azurerm_subnet.databricks_public_subnet.id
  nat_gateway_id = var.nat_gateway_id
}

# Associate the NAT Gateway with the Databricks Private Subnet
resource "azurerm_subnet_nat_gateway_association" "databricks_private" {
  subnet_id      = azurerm_subnet.databricks_private_subnet.id
  nat_gateway_id = var.nat_gateway_id
}

# Enable logs for Databricks workspace
resource "azurerm_monitor_diagnostic_setting" "dbx" {
  name                       = "${var.client}_dbx_logs_${var.suffix}"
  target_resource_id         = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id = var.log_analytics_id

  dynamic "enabled_log" {
    for_each = var.dbx_logs
    content {
      category = enabled_log.value
    }
  }
}