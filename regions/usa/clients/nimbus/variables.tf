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

variable "username" {
  description = "Username for accounts"
  type        = string
}

variable "vm_private_ip" {
  description = "Static private IP address for the VM"
  type        = string
}

variable "region" {
  description = "Region where resources will be created"
  type = string
}

variable "client" {
  description = "Client name for resource naming"
  type = string
}

variable "environment" {
  description = "Numerical identifier for resources"
  type        = string
}

variable "owner" {
  description = "Owner of the project or resources"
  type = string
}

variable "project" {
  description = "Main project associated with this deployment"
  type        = string
}

variable "created_by" {
  description = "Tag showing Terraform created this resource"
  type        = string
}

variable "monitoring_subscription_id" {
  description = "Subscription ID where Log Analytics workspace exists"
  type        = string
}

variable "management_subscription_id" {
  description = "Subscription ID where DBX workspace and storage for state exists"
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

variable "adls_logs" {
  description = "List of Data Lake logs to enable"
  type        = list(string)
  default     = []
}

variable "deploy_service_principal" {
  description = "Whether to deploy the service principal module"
  type        = bool
}