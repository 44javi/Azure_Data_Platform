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

variable "secondary_region" {
  description = "2nd region for resource creation"
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

variable "alert_email" {
  description = "Email used for monitoring alerts"
  type        = string
}

variable "owner" {
  description = "Person responsible for the resource"
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

variable "bronze_container" {
  description = "Container for Raw/ingested data"
  type        = string
}

variable "gold_container" {
  description = "Container for processed/refined data"
  type        = string
}

variable "metastore_id" {
  description = "ID of the default Databricks metastore"
  type        = string
}

variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "root_management_group_id" {
  description = "The ID of the Root Management Group"
  type        = string
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
