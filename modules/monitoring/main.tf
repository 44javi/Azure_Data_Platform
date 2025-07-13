resource "azurerm_monitor_action_group" "alerts" {
  name                = "alerts-${var.client}-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "alerts"

  email_receiver {
    name          = "alerts"
    email_address = var.alert_email
  }
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log${var.client}${var.environment}"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"   # SKUs: Free, PerGB2018, Standalone, CapacityReservation
  retention_in_days   = 30            # Retention period for logs (30-730 days)

  daily_quota_gb             = 1 # -1 for unlimited
  internet_ingestion_enabled = true
  internet_query_enabled     = true

  tags = var.default_tags
}