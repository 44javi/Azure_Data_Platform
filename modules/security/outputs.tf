# /modules/security/outputs.tf

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "data_engineers_group_id" {
  description = "Object ID of the Data Engineers security group"
  value       = data.azuread_group.data_engineers.object_id
}

output "data_engineers_display_name" {
  description = "The display name of the Data Engineers group"
  value       = data.azuread_group.data_engineers.display_name
}


