# Variables
# ------------------

# Locals
# ------------------

# Resources
# -----------------
resource "azurerm_linux_virtual_machine" "virtual_machine" {
 name                  = var.virtual_machine_name
 location              = var.location
 resource_group_name   = azurerm_resource_group.resource_group.name
 network_interface_ids = [azurerm_network_interface.network_interface_card.id]
 size                  = var.disksize

 os_disk {
   name                 = var.os_disk_name
   caching              = var.os_disk_caching
   storage_account_type = var.os_disk_storage_account_type
 }

 source_image_reference {
   publisher = var.source_image_reference_publisher
   offer     = var.source_image_reference_offer
   sku       = var.source_image_reference_sku
   version   = var.source_image_reference_version
 }

 computer_name                   = var.virtual_machine_name
 admin_username                  = var.vm_admin_username
 disable_password_authentication = var.vm_disable_password_authentication

 admin_ssh_key {
   username   = var.vm_admin_username
   public_key = tls_private_key.ssh_key.public_key_openssh
 }

 boot_diagnostics {
   storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
 }

}

# Outputs
# -----------------

