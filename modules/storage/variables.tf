# Data_resources module variables

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_id" {
  description = "The full resource ID of the resource group"
  type        = string
}

variable "region" {
  description = "Region where resources will be created"
  type        = string
}

variable "client" {
  description = "Client name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment for resources"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
}

variable "subnet_id" {
  description = "Private subnet id"
  type        = string
}

variable "vnet_id" {
  description = "Hub virtual network id"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "log_analytics_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
}

variable "adls_logs"{
  description = "List of Data Lake logs to enable"
  type = list(string)
  default = []
}

variable "containers" {
  description = "Storage containers for data lake"
  type        = list(any)
}
