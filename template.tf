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

# =============================================================================
# PROJECT & ENVIRONMENT CONFIGURATION
# =============================================================================
client      = ""
environment = ""
region      = ""
owner       = ""
project     = "Data Platform"
created_by  = "Terraform"

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================
vnet_address_space = [""]

# Subnet address mappings
subnet_address_prefixes = {
  public_subnet             = ""   # Public subnet for VMs
  private_subnet            = ""   # Private subnet for VMs
  bastion_subnet            = ""   # Subnet for Azure Bastion
  databricks_public_subnet  = ""   # Public subnet for Databricks
  databricks_private_subnet = ""   # Private subnet for Databricks
}

# Access to public VMs
trusted_ip_ranges = [
  ""
]

# =============================================================================
# COMPUTE & VM CONFIGURATION
# =============================================================================
username = ""
vm_private_ip = ""

# =============================================================================
# DATA PLATFORM CONFIGURATION
# =============================================================================

# Lists of Data lake containers
containers    = ["bronze", "silver", "gold", "catalog"]

# Databricks Unity Catalog schemas
schemas       = ["bronze", "silver", "gold"]

# =============================================================================
# MONITORING & LOGGING CONFIGURATION
# =============================================================================
alert_email = ""

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

# =============================================================================
# RBAC & PERMISSIONS CONFIGURATION
# =============================================================================

# Key vault permissions
kv_rbac = {
  data_engineers = {
    group_name           = "Data_Engineers"
    role_definition_name = "Key Vault Secrets User"  
  }
  test_team = {
    group_name           = "Test_Team"
    role_definition_name = "Key Vault Secrets User"
  }
}

# Datalake (ADLS) permissions
adls_rbac = {
  data_engineers = {
    group_name           = "Data_Engineers"
    role_definition_name = "Storage Blob Data Contributor"
  }

#  external_users = {
#    group_name           = "External_Users"
#    role_definition_name = "Storage Blob Data Reader"
#  }
}

# Databricks (dbx) workspace permissions (Control Plane)
dbx_rbac = {
   data_engineers = {
    group_name           = "Data_Engineers"
    role_definition_name = "Reader"
  }
}


*/
