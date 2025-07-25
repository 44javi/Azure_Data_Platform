## Resources

| Name | Description | Type |
|------|-------------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | Creates Azure Key Vault for secrets, keys and certificates | resource |
| [azurerm_role_assignment.data_engineers_keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | Assigns roles to data engineers group for Key Vault access | resource |
| [azuread_group.data_engineers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | Retrieves existing data engineers Azure Entra ID group | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | Retrieves metadata for the current Azure client, including tenant ID, client ID, and object ID | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client"></a> [client](#input\_client) | Client name | `string` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags for resources | `map(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Unique environment for naming | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for deployment | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_engineers_display_name"></a> [data\_engineers\_display\_name](#output\_data\_engineers\_display\_name) | The display name of the Data Engineers group |
| <a name="output_data_engineers_group_id"></a> [data\_engineers\_group\_id](#output\_data\_engineers\_group\_id) | Object ID of the Data Engineers security group |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | n/a |
