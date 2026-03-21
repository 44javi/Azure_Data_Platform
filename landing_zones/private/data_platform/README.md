# Azure Data Platform 

A repository for automating **Azure** and **Databricks** deployments with **Terraform**.

---

## Table of Contents

- [Pre-requisites](#pre-requisites)
- [Deployment Steps](#deployment-steps)
- [Diagrams](#diagrams)
- [Project Structure](#project-structure)
- [Resources Documentation](#resources-documentation)

---

## Pre-requisites

- Create Azure management group
- Set Subscriptions
- Azure CLI - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
- Databricks CLI - https://docs.databricks.com/en/dev-tools/cli/install.html
- Terraform - https://developer.hashicorp.com/terraform/install

## Deployment Steps

1. Initial Deployment
   - `chmod +x ./.debug.prod.sh`
   - `./.debug.prod.sh plan`
   - `./.debug.prod.sh apply` to deploy the initial infrastructure
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
   - Run `./.debug.prod.sh apply` again to complete the deployment of resources

---

## Diagrams

### Azure data lake and Databricks

![Azure resources](assets/azure_resources.png)

### Databricks Architecture

![Databricks Diagram](assets/databricks_workspace.png)

> **Note:** The diagrams are a **high level overview** and don't capture the **all deployed resources**.

---

## Project Structure

```
/azure-terraform
├── /env                          # Environment configurations
│   └── prod.tfvars
│               
├── /modules
│   ├── /compute                  # Module for compute related resources
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── /storage                  # Module for storage related resources
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── /dbx_workspace            # Module for Databricks workspace with VNET injection
│   │   ├── main.tf               # Workspace, subnets, NSGs, and NAT gateway
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── /security                 # Module for security related resources
│   │   ├── main.tf               # Service principals, Key vault, security groups, etc
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
│   └── /unity_catalog            # Module for databricks workspace resources
│       ├── main.tf               # Catalogs, schemas, and external locations
│       ├── variables.tf
│       └── outputs.tf
│
├── /regions
│   ├── /us
│   │   ├── /management
│   │   │   ├── /env
│   │   │   │   └── prod.tfvars
│   │   │   ├── .debug.prod.sh
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── /clients
│   │       ├── /client-a
│   │       │   ├── /env
│   │       │   │   └── prod.tfvars
│   │       │   ├── .debug.prod.sh
│   │       │   ├── main.tf
│   │       │   ├── variables.tf
│   │       │   └── outputs.tf
│   │       └── /client-b
│   │           ├── /env
│   │           │   └── prod.tfvars
│   │           ├── .debug.prod.sh
│   │           ├── main.tf
│   │           ├── variables.tf
│   │           └── outputs.tf
│   │
│   └── /japan
│       ├── /management
│       │   ├── /env
│       │   │   └── prod.tfvars
│       │   ├── .debug.prod.sh
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── /clients
│           └── /client-c
│               ├── /env
│               │   └── prod.tfvars
│               ├── .debug.prod.sh
│               ├── main.tf
│               ├── variables.tf
│               └── outputs.tf
├── .debug.prod.sh                # Sets the backend and some environment variables
├── iam.tf                        # Creates security groups
├── main.tf                       # Core configuration to orchestrate modules
├── versions.tf                   # Azure and Databricks providers
├── variables.tf                  # Variables for the project
├── management_groups.tf          # Sets management group hierarchy
├── outputs.tf                    # Root module outputs
└── README.md                     # Project documentation
└── template.tf                   # Templates for tfvars and debug.sh files

```
