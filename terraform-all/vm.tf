# Variables
# ------------------

# Locals
# ------------------

# Resources
# -----------------
resource "azurerm_linux_virtual_machine" "virtual_machine" {
 name                  = var.virtual_machine_name
 location              = var.location
 resource_group_name   = azurerm_resource_group.main_rg.name
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
 admin_password                  = var.vm_admin_password
 disable_password_authentication = var.vm_disable_password_authentication



 boot_diagnostics {
   storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
 }

}

 resource "azurerm_network_interface" "network_interface_card" {
  name                = "networkInterface"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.sqube_subnet.id
    private_ip_address_allocation = "static"
  } 
 }


resource "azurerm_public_ip" "pip" {
  name                = "pip1"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allocation_method   = "Static"
}

