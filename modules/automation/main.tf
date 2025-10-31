# /modules/automation/main.tf

# Get current Azure config
data "azurerm_subscription" "current" {}

resource "azurerm_automation_account" "this" {
  name                = "aa-pdh"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aa_vm_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id

  lifecycle {
    ignore_changes = [ scope ]
  }
}

# ================= RUNBOOK =================
resource "azurerm_automation_runbook" "manage_vms" {
  name                    = "rb-manage-vms"
  location                = var.region
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  runbook_type            = "PowerShell"
  log_verbose             = false
  log_progress            = false
  content                 = file("${path.module}/scripts/automation/manage-vms.ps1")
}

# ================= DEV and QA SCHEDULES =================

# Schedule to stop VMs in DEV and QA every day except Thursdays.
resource "azurerm_automation_schedule" "std_stop" {
  name                    = "dev-qa-off"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  timezone                = "America/Chicago"
  start_time              = "2025-10-30T20:00:00-05:00" # 8pm CST
  week_days               = ["Monday", "Tuesday", "Wednesday", "Friday"]
  description             = "Standard shutdown schedule for DEV and QA environments"
}

# Schedule to stop VMs in DEV and QA environments. Thursdays at 12am
resource "azurerm_automation_schedule" "thursday_stop" {
  name                    = "thursday-sch-off"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  timezone                = "America/Chicago"
  start_time              = "2025-10-31T00:00:00-05:00"  # 12am CST
  week_days               = ["Thursday"]
  description             = "Thursday midnight shutdown schedule for DEV and QA environments"
}

# # locals used to pass environments to runbook
# locals {
#   shutdown_envs = ["DEV", "QA"]
# }

# Link schedule to runbook
resource "azurerm_automation_job_schedule" "stop_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.std_stop.name
  runbook_name            = azurerm_automation_runbook.manage_vms.name

  parameters = {
    tagkey   = "Environment"
    tagvalue = "DEV|QA"
    action   = "stop"
  }
}

resource "azurerm_automation_job_schedule" "thursday_stop_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.thursday_stop.name
  runbook_name            = azurerm_automation_runbook.manage_vms.name
  parameters = {
    tagkey   = "Environment"
    tagvalue = "DEV|QA"
    action   = "stop"
  }
}

# ================= PROD SCHEDULES =================
# Schedule to stop VMs in PROD every weekday.
resource "azurerm_automation_schedule" "prod_stop" {
  name                    = "prod-weekday-off"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  timezone                = "America/Chicago"
  start_time              = "2025-10-31T20:00:00-05:00" # 8pm CST
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  description             = "Standard shutdown schedule for the PROD environment"
  lifecycle {
    #ignore_changes = [start_time]
  }
}

# Link PROD schedule to runbook
resource "azurerm_automation_job_schedule" "prod_stop_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.prod_stop.name
  runbook_name            = azurerm_automation_runbook.manage_vms.name

  parameters = {
    tagkey   = "Environment"
    tagvalue = "PROD"
    action   = "stop"
  }
}

resource "azurerm_automation_schedule" "prod_patch_start" {
  name                    = "prod-patch-sch-on"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  timezone                = "America/Chicago"
  start_time              = "2025-10-31T20:00:00-05:00" # 8pm CST
  week_days               = ["Saturday"]
  description             = "PATCH schedule for PROD environments"
}

resource "azurerm_automation_job_schedule" "prod_start_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.prod_patch_start.name
  runbook_name            = azurerm_automation_runbook.manage_vms.name

  parameters = {
    tagkey   = "Environment"
    tagvalue = "PROD"
    action   = "start"
  }
}

resource "azurerm_automation_schedule" "prod_patch_stop" {
  name                    = "prod-patch-sch-stop"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  timezone                = "America/Chicago"
  start_time              = "2025-10-31T00:00:00-05:00"  # 12am CST
  week_days               = ["Saturday"]
  description             = "PATCH stop schedule for PROD environments"
}

resource "azurerm_automation_job_schedule" "prod_patch_stop_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.prod_patch_stop.name
  runbook_name            = azurerm_automation_runbook.manage_vms.name

  parameters = {
    tagkey   = "Environment"
    tagvalue = "PROD"
    action   = "stop"
  }
}

# ================= START SCHEDULE =================
# For all environments

resource "azurerm_automation_schedule" "vm_start" {
  name                    = "everyday-sch-on"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  timezone                = "America/Chicago"
  start_time              = "2025-10-31T06:00:00-05:00" # 6am CST
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  description             = "Startup schedule for DEV, QA and PROD environments"
}

resource "azurerm_automation_job_schedule" "start_link" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.vm_start.name
  runbook_name            = azurerm_automation_runbook.manage_vms.name
  
  parameters = {
    tagkey   = "Environment"
    tagvalue = "DEV|QA|PROD"
    action   = "start"  
  }
}