## Resources

| Name | Description | Type |
|------|-------------|------|
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | Creates the Azure Databricks workspace | resource |
| [azurerm_monitor_diagnostic_setting.dbx](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | Enables the logs to send to the log analytic workspace for the Databricks workspace | resource |
| [azurerm_network_security_group.databricks_private_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | Creates network security group for the Databricks private subnet | resource |
| [azurerm_network_security_group.databricks_public_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | Creates network security group for the Databricks public subnet | resource |
| [azurerm_role_assignment.data_engineers_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | Assigns roles to data engineers group for workspace access | resource |
| [azurerm_subnet.databricks_private_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | Creates private subnet for Databricks clusters| resource |
| [azurerm_subnet.databricks_public_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | Creates public subnet for Databricks clusters | resource |
| [azurerm_subnet_nat_gateway_association.databricks_private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | Associates NAT gateway with private subnet for cluster outbound connectivity | resource |
| [azurerm_subnet_nat_gateway_association.databricks_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | Associates NAT gateway with public subnet for cluster outbound connectivity | resource |
| [azurerm_subnet_network_security_group_association.nsg_assoc_private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | Associates network security group with private subnet | resource |
| [azurerm_subnet_network_security_group_association.nsg_assoc_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | Associates network security group with public subnet | resource |
| [azuread_group.data_engineers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | Retrieves existing data engineers Azure AD group to assign permissions | data source |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_client"></a> [client](#input\_client) | Client name | `string` | n/a | yes |
| <a name="input_dbx_logs"></a> [dbx\_logs](#input\_dbx\_logs) | List of Databricks log categories to enable | `list(string)` | `[]` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags for resources | `map(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for naming | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | ID of the Log Analytics workspace | `string` | n/a | yes |
| <a name="input_nat_gateway_id"></a> [nat\_gateway\_id](#input\_nat\_gateway\_id) | nat gateway id | `string` | n/a | yes |
| <a name="input_public_ip_id"></a> [public\_ip\_id](#input\_public\_ip\_id) | id of gateway public ip | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for deployment | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | A map of address prefixes for each subnet | `map(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Private subnet id | `string` | n/a | yes |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | The ID of the Virtual Network where the Databricks workspace will be deployed | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the virtual network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databricks_private_subnet_name"></a> [databricks\_private\_subnet\_name](#output\_databricks\_private\_subnet\_name) | n/a |
| <a name="output_databricks_private_subnet_nsg_assoc_id"></a> [databricks\_private\_subnet\_nsg\_assoc\_id](#output\_databricks\_private\_subnet\_nsg\_assoc\_id) | n/a |
| <a name="output_databricks_public_subnet_name"></a> [databricks\_public\_subnet\_name](#output\_databricks\_public\_subnet\_name) | n/a |
| <a name="output_databricks_public_subnet_nsg_assoc_id"></a> [databricks\_public\_subnet\_nsg\_assoc\_id](#output\_databricks\_public\_subnet\_nsg\_assoc\_id) | n/a |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | n/a |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | n/a |
