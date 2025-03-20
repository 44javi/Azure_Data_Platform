# Random string for VM name
resource "random_string" "vm_name_suffix" {
  length  = 9
  upper   = false
  special = false
  numeric = true
}
 
# Random name for SSH key
resource "random_pet" "ssh_key_name" {
  length = 2
}
 
# Create the SSH public key in Azure
resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = var.region
  parent_id = var.resource_group_id
}
 
# Generate the SSH key pair
resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"
 
  response_export_values = ["*"]
}
 
locals {
  ssh_private_key = azapi_resource_action.ssh_public_key_gen.output["privateKey"]
  ssh_public_key  = azapi_resource_action.ssh_public_key_gen.output["publicKey"]
}
 
resource "local_file" "private_key" {
  content         = sensitive(local.ssh_private_key)
  filename        = "${path.module}/ssh_private_key.pem"
  file_permission = "0600"  # Restricted permissions for SSH key
}
 
# Create the Virtual Machine
resource "azurerm_linux_virtual_machine" "this" {
  name                = "doc_vm${random_string.vm_name_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.region
  size                = "Standard_D4s_v3"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]
 
  admin_ssh_key {
    username   = var.username
    public_key = local.ssh_public_key
  }
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 256
  }
 
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-LVM"
    version   = "latest"
  }
/*
  custom_data = <<-EOF
    #cloud-config
    runcmd:
      - sudo growpart /dev/sda 4
      - sudo pvresize /dev/sda 4
      - sudo lvextend -1 +100%FREE /dev/mapper/rootvg-homelv
      - sudo xfs_growfs /home
    EOF
    #`lsblk`
*/
  computer_name                   = "doc-vm"
  disable_password_authentication = true
 
  tags = var.default_tags
}
 
 
# Create Public IP for VM
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.client}_doc_vm_pip_${var.suffix}"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"  
 
  tags = var.default_tags
}
 
# Create the Network Interface
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.client}_doc_nic_${var.suffix}"
  location            = var.region
  resource_group_name = var.resource_group_name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.44.0.10"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
  tags = var.default_tags
}