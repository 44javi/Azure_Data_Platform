resource "azurerm_automation_account" "this" {
  name                = "aa-${var.client}-${var.environment}"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = var.default_tags
}

resource "azurerm_role_assignment" "aa_vm_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id
}

# ================= RUNBOOKS =================

# Stop VMs Based on Tag
resource "azurerm_automation_runbook" "stop_vm" {
  name                    = "rb-stopvm-${var.client}-${var.environment}"
  location                = var.region
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = false
  log_progress            = false
  runbook_type            = "PowerShell"
  content                 = file("${path.module}/runbooks/std-stop-vms.ps1")
}

# Start VMs Based on Tag
resource "azurerm_automation_runbook" "start_vm" {
  name                    = "rb-startvm-${var.client}-${var.environment}"
  location                = var.region
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  runbook_type            = "PowerShell"
  log_verbose             = false
  log_progress            = false
  content                 = file("${path.module}/runbooks/std-start-vms.ps1")
}

# ================= STANDARD SCHEDULE =================

resource "azurerm_automation_schedule" "std_stop" {
  name                    = "sch-std-off-${var.client}-${var.environment}"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Day"
  timezone                = "America/Chicago"
  start_time              = timeadd(timestamp(), "23h")

  lifecycle {
    ignore_changes = [start_time]
  }
}

resource "azurerm_automation_schedule" "std_start" {
  name                    = "sch-std-on-${var.client}-${var.environment}"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Day"
  timezone                = "America/Chicago"
  start_time              = timeadd(timestamp(), "13h")

  lifecycle {
    ignore_changes = [start_time]
  }
}


# Link schedule to runbook
resource "azurerm_automation_job_schedule" "std_stop_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.std_stop.name
  runbook_name            = azurerm_automation_runbook.stop_vm.name

  parameters = {
    tagkey   = "shutdown_standard"
    tagvalue = "true"
  }
}

resource "azurerm_automation_job_schedule" "std_start_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.std_start.name
  runbook_name            = azurerm_automation_runbook.start_vm.name

  parameters = {
    tagkey   = "shutdown_standard"
    tagvalue = "true"
  }
}

