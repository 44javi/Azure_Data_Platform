# root variables.tf

variable "client" {
  description = "Client name for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment for the resources"
  type        = string
}

variable "region" {
  description = "Region where resources will be created"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}


variable "subnet_address_prefixes" {
  description = "A map of address prefixes for each subnet"
  type        = map(string)
}

variable "trusted_ip_ranges" {
  description = "List of trusted IP ranges for access to public VMs"
  type        = list(string)
}

variable "vm_private_ip" {
  description = "Static private IP address for the VM"
  type        = string
}

variable "alert_email" {
  description = "Email used for monitoring alerts"
  type        = string
}

variable "owner" {
  description = "Owner of the project or resources"
  type        = string
}

variable "project" {
  description = "Main project associated with this deployment"
  type        = string
}

variable "created_by" {
  description = "Tag showing Terraform created this resource"
  type        = string
}

variable "containers" {
  description = "Storage containers for data lake"
  type        = list(any)
}

variable "schemas" {
  description = "Schema names for dbx catalog"
  type        = list(any)
}

variable "dbx_logs" {
  description = "List of Databricks logs to enable"
  type        = list(string)
  default     = []
}

variable "adls_logs" {
  description = "List of Data Lake logs to enable"
  type        = list(string)
  default     = []
}

variable "username" {
  description = "Username for accounts"
  type        = string
}

variable "kv_rbac" {
  description = "Map of group based role assignments for Key Vault"
  type = map(object({
    group_name           = string
    role_definition_name = string
  }))
}

variable "adls_rbac" {
  description = "Map of group based role assignments for ADLS"
  type = map(object({
    group_name           = string
    role_definition_name = string
  }))
}

variable "dbx_rbac" {
  description = "Map of group based role assignments for dbx workspace"
  type = map(object({
    group_name           = string
    role_definition_name = string
  }))
}

variable "deploy_compute" {
  description = "Whether to deploy the compute module"
  type        = bool
}

variable "deploy_automation" {
  description = "Whether to deploy the compute module"
  type        = bool
}

variable "st_retention_days" {
  description = "Number of days to retain deleted blobs and containers"
  type        = number
  default     = 30
}

variable "vm_schedules" {
  description = "VM start/stop schedules"
  type = map(object({
    frequency   = string
    start_time  = string
    week_days   = list(string)
    description = string
    vm_names    = string
    action      = string
  }))
  default = {}
}