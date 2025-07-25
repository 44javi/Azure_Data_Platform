## Resources

| Name | Description | Type |
|------|-------------|------|
| [azurerm_monitor_diagnostic_setting.adls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | Enables logs for Azure Data Lake to send to the log analytic workspace | resource |
| [azurerm_private_endpoint.adls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | Creates private endpoint for Data Lake access | resource |
| [azurerm_role_assignment.data_engineers_datalake](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | Assigns roles to data engineers group for the Data Lake | resource |
| [azurerm_storage_account.adls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | Creates Azure Data Lake Storage Gen2 account | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | Creates storage containers within the Data Lake | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | Generates random string for data lake name | resource |
| [azuread_group.data_engineers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | Retrieves existing data engineers Azure Entra ID group | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | Retrieves metadata for the current Azure client, including tenant ID, client ID, and object ID | data source |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_adls_logs"></a> [adls\_logs](#input\_adls\_logs) | List of Data Lake logs to enable | `list(string)` | `[]` | no |
| <a name="input_client"></a> [client](#input\_client) | Client name for resource naming | `string` | n/a | yes |
| <a name="input_containers"></a> [containers](#input\_containers) | Storage containers for data lake | `list(any)` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for resources | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | ID of the Log Analytics workspace | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where resources will be created | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The full resource ID of the resource group | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Private subnet id | `string` | n/a | yes |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | Hub virtual network id | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the virtual network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datalake_connection"></a> [datalake\_connection](#output\_datalake\_connection) | The primary connection string for the storage account |
| <a name="output_datalake_endpoint"></a> [datalake\_endpoint](#output\_datalake\_endpoint) | The primary Blob service endpoint for the storage account |
| <a name="output_datalake_id"></a> [datalake\_id](#output\_datalake\_id) | The resource ID of the Azure Data Lake Storage account |
| <a name="output_datalake_name"></a> [datalake\_name](#output\_datalake\_name) | The name of the Azure Data Lake Storage account |
