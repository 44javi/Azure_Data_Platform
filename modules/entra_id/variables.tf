# /modules/entra_id/variables.tf

variable "client" {
  description = "Client name"
  type        = string
}

variable "suffix" {
  description = "Unique suffix for naming"
  type        = string
}

variable "workspace_id" {
  description = "The ID of the Databricks workspace"
  type        = string
}

variable "workspace_url" {
  description = "The URL of the Databricks workspace"
  type        = string
}

variable "datalake_id" {
  description = "The ID of the data lake storage account"
  type        = string
}

variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

