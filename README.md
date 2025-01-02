# Azure_Data_Platform

A repository for automating Azure and Databricks deployment with Terraform.

## Project Structure

```
/azure-terraform
├── /environments                  # Environment configurations
│   └── backend_dev.hcl            # Backend configuration for dev environment
├── /modules
│   ├── /data_resources           # Module for storage related resources
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── /entra_id                 # Module for Entra ID resources
│   │   ├── main.tf               # Service principals, app registrations, groups
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── /inactive_resources       # Module for resources currently not in use
│   │   ├── main.tf
│   ├── /monitoring               # Module for monitoring and logging resources
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── /network                  # Module for networking components
│   │   ├── main.tf               # VNets, public/private subnets, NSGs, etc
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── /unity_catalog           # Module for Unity Catalog resources
│       ├── main.tf               # Catalogs, schemas, and external locations
│       ├── variables.tf
│       └── outputs.tf
├── module_blocks.tf              # Core configuration to orchestrate modules
├── provider.tf                   # Azure providers
├── variables.tf                  # Variables for the project
├── variables.auto.tfvars         # Default values for variables
├── management_resources.tf       # For resources that apply to all modules
├── outputs.tf                    # Root module outputs
└── README.md                     # Project documentation

```

## Pre-requisites

- Create Azure management group
- Subscriptions
- Assign Storage Blob Data Contributor to admins
- Databricks CLI - https://docs.databricks.com/en/dev-tools/cli/install.html
- Terraform - https://developer.hashicorp.com/terraform/install

## Deployment Steps

1. Initial Deployment
   - `terraform init`
   - `terraform plan`
   - `terraform apply` to deploy the initial infrastructure
2. Databricks Configuration
   - After the Databricks workspace is created, navigate to the workspace in the Azure portal
   - Generate a personal access token (User Settings → Developer → New Token)
   - Configure the Databricks CLI:
     ```bash
     databricks configure --token
     ```
   - Enter the workspace URL and access token when prompted
   - This creates a `~/.databrickscfg` file that enables authentication and resource creation
3. Final Deployment
   - Run `terraform apply` again to complete the deployment of resources

<!-- BEGIN_TF_DOCS -->

## Providers

| Name                                                                        | Version  |
| --------------------------------------------------------------------------- | -------- |
| <a name="requirement_azuread"></a> [azuread](#requirement_azuread)          | ~> 3.0   |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)          | ~> 4.9   |
| <a name="requirement_databricks"></a> [databricks](#requirement_databricks) | ~> 1.6   |
| <a name="requirement_random"></a> [random](#requirement_random)             | ~> 3.6.3 |

## Modules

| Name                                                                          | Source                   | Version |
| ----------------------------------------------------------------------------- | ------------------------ | ------- |
| <a name="module_data_resources"></a> [data_resources](#module_data_resources) | ./modules/data_resources | n/a     |
| <a name="module_network"></a> [network](#module_network)                      | ./modules/network        | n/a     |

## Resources

| Name                                                                                                                          | Type     |
| ----------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name                                                                                                   | Description                                      | Type           | Default | Required |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------------------ | -------------- | ------- | :------: |
| <a name="input_alert_email"></a> [alert_email](#input_alert_email)                                     | Email used for monitoring alerts                 | `string`       | n/a     |   yes    |
| <a name="input_bronze_container"></a> [bronze_container](#input_bronze_container)                      | Container for raw/ingested data                  | `string`       | n/a     |   yes    |
| <a name="input_client"></a> [client](#input_client)                                                    | Client name for resource naming.                 | `string`       | n/a     |   yes    |
| <a name="input_created_by"></a> [created_by](#input_created_by)                                        | Tag showing Terraform created this resource      | `string`       | n/a     |   yes    |
| <a name="input_environment"></a> [environment](#input_environment)                                     | Environment for the resources (e.g., dev, prod). | `string`       | n/a     |   yes    |
| <a name="input_gold_container"></a> [gold_container](#input_gold_container)                            | Container for processed/refined data             | `string`       | n/a     |   yes    |
| <a name="input_owner"></a> [owner](#input_owner)                                                       | Person responsible for the resource              | `string`       | n/a     |   yes    |
| <a name="input_project"></a> [project](#input_project)                                                 | Main project associated with this deployment     | `string`       | n/a     |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                    | Region where resources will be created           | `string`       | n/a     |   yes    |
| <a name="input_subnet_address_prefixes"></a> [subnet_address_prefixes](#input_subnet_address_prefixes) | A map of address prefixes for each subnet        | `map(string)`  | n/a     |   yes    |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id)                         | Subscription_ID to deploy resources to           | `string`       | n/a     |   yes    |
| <a name="input_suffix"></a> [suffix](#input_suffix)                                                    | Numerical identifier for resources               | `string`       | n/a     |   yes    |
| <a name="input_vnet_address_space"></a> [vnet_address_space](#input_vnet_address_space)                | The address space for the virtual network        | `list(string)` | n/a     |   yes    |

## Outputs

| Name                                                                                         | Description                                                     |
| -------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| <a name="output_resource_group_id"></a> [resource_group_id](#output_resource_group_id)       | main resource group where most resources will be placed         |
| <a name="output_resource_group_name"></a> [resource_group_name](#output_resource_group_name) | name of main resource group where most resources will be placed |

<!-- END_TF_DOCS -->
