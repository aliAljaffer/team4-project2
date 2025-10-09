resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                  = var.virtual_machine_name
  location              = var.rg_location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.network_interface_card.id]
  size                  = var.vm_size

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
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.vm_disable_password_authentication


}

resource "azurerm_network_interface" "network_interface_card" {
  name                = "networkInterface"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_public_ip" "pip" {
  name                = "pip1"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}
