resource "azurerm_linux_virtual_machine" "sq_vm" {
  name                = "${var.resource_prefix}-vm"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  disable_password_authentication = false
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }
  network_interface_ids = [azurerm_network_interface.sq_nic.id]

  custom_data = filebase64("${path.module}/cloud-init/sonarqube-install.sh")
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.resource_prefix}-main-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "sq_nic" {
  name                = "${var.resource_prefix}-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  ip_configuration {
    primary                       = true
    name                          = "primary"
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }
}
