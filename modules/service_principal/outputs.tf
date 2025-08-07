# Outputs
output "service_principal_object_id" {
  description = "Object ID of the service principal"
  value       = azuread_service_principal.this.object_id
}

output "certificate_name" {
  description = "Name of the certificate in Key Vault"
  value       = azurerm_key_vault_certificate.sp_cert.name
}

output "key_vault_certificate_id" {
  description = "Key Vault certificate ID"
  value       = azurerm_key_vault_certificate.sp_cert.id
}

output "certificate_secret_id" {
  description = "Key Vault secret ID for the certificate"
  value       = azurerm_key_vault_certificate.sp_cert.secret_id
  sensitive = true
}