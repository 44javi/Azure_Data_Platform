## Resources

| Name | Description | Type |
|------|-------------|------|
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | Creates Log Analytics workspace for monitoring and logging | resource |
| [azurerm_monitor_action_group.alerts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | Creates action group for monitoring alerts and notifications | resource |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_alert_email"></a> [alert\_email](#input\_alert\_email) | Email used for monitoring alerts | `string` | n/a | yes |
| <a name="input_client"></a> [client](#input\_client) | Client name for resource naming | `string` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where resources will be created | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The full resource ID of the resource group | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_id"></a> [log\_analytics\_id](#output\_log\_analytics\_id) | n/a |
| <a name="output_log_analytics_name"></a> [log\_analytics\_name](#output\_log\_analytics\_name) | n/a |
