# /modules/security/variables.tf

variable "client" {
  description = "Client name"
  type        = string
}

variable "environment" {
  description = "Unique environment for naming"
  type        = string
}

variable "workspace_id" {
  description = "The ID of the Databricks workspace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group"
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

variable "region" {
  description = "Region for deployment"
  type        = string
}

variable "default_tags" {
  description = "Default tags for resources"
  type        = map(string)
}
