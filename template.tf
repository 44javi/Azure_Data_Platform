# .debug.prod.sh - Fill in the template variables
/*
# set the subscription
export ARM_SUBSCRIPTION_ID=""

# set the project / environment
export TF_VAR_client="client"
export TF_VAR_environment="prod"

# set the backend
export BACKEND_RESOURCE_GROUP=""
export BACKEND_STORAGE_ACCOUNT=""
export BACKEND_STORAGE_CONTAINER=""
export BACKEND_KEY=$TF_VAR_client-$TF_VAR_environment

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}" \
    -reconfigure

terraform $* -var-file=./env/${TF_VAR_environment}.tfvars

# clean up the local environment
rm -rf .terraform


------------------------------------------------------------------------------------------------------------------------

#.tfvars

#Root Management Group ID
root_management_group_id = ""

# Resource Naming
client      = "nimbus"
environment = "prod"

region             = "westus2"
secondary_region   = "eastus2"

alert_email = "j@protonmail.com"

vnet_address_space = ["10.79.0.0/16"]

# Map of addresses for each subnet
subnet_address_prefixes = {
  public_subnet             = "10.79.0.0/26" # Public subnet for VMs
  private_subnet            = "10.79.1.0/26" # Private subnet for VMs
  bastion_subnet            = "10.79.2.0/26" # Subnet for Azure Bastion
  databricks_public_subnet  = "10.79.3.0/24" # Public subnet for Databricks
  databricks_private_subnet = "10.79.4.0/24" # Private subnet for Databricks
}

# Access to public VMs
trusted_ip_ranges = [
  ""
]

# VM Admin
username = ""

# Lists of Data lake container names and schemas for dbx
containers    = ["bronze", "silver", "gold", "catalog"]
schemas       = ["bronze", "silver", "gold"]

# List of Databricks log categories to enable
dbx_logs = [
  "clusters",
  "jobs",
  "notebook",
  "dbfs",
  "secrets",
  "sqlPermissions",
  "unityCatalog"
]

# List of Azure Data Lake logs to enable
adls_logs =[
  "StorageWrite"
]



# Default tags
owner       = "Javier"
project     = "Data Platform"
created_by  = "Terraform"


*/
