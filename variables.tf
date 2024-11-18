# root variables.tf

variable "client" {
  description = "Client name for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment for the resources (e.g., dev, prod)."
  type        = string
}

# Region
variable "region" {
  description = "Region where resources will be created"
  type        = string
}

# Resource Group Name
#variable "resource_group_name" {
#  description = "Name of the resource group"
#  type        = string
#}

# VNET address space
variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

# Subnet address prefixes
variable "subnet_address_prefixes" {
  description = "A map of address prefixes for each subnet"
  type        = map(string)
}

variable "alert_email" {
  description = "Email used for monitoring alerts"
  type        = string
}

variable "suffix" {
  description = "Numerical identifier for resources"
  type        = string
}

variable "owner" {
  description = "Person responsable for the resource"
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

variable "subscription_id" {
  description = "Subcription_ID to deploy resources to"
  type        = string
}