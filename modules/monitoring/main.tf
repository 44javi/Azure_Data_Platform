resource "azurerm_monitor_action_group" "alerts" {
  name                = "${var.client}_dbx_alerts"
  resource_group_name = var.resource_group_name
  short_name          = "dbx_alerts"

  email_receiver {
    name          = "dbx_alerts"
    email_address = var.alert_email
  }
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.client}logs${var.suffix}"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"   # SKUs: Free, PerGB2018, Standalone, CapacityReservation
  retention_in_days   = 30            # Retention period for logs (30-730 days)

  daily_quota_gb             = 5 # -1 for unlimited
  internet_ingestion_enabled = true
  internet_query_enabled     = true

  tags = var.default_tags
}