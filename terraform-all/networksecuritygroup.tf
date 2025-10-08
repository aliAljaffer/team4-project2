resource "azurerm_network_security_group" "be_nsg" {
  name                = "${var.resource_prefix}-be-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  # SECURITY RULES HERE
}
resource "azurerm_network_security_group" "fe_nsg" {
  name                = "${var.resource_prefix}-fe-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  # SECURITY RULES HERE
}

resource "azurerm_subnet_network_security_group_association" "fe_assoc" {
  network_security_group_id = azurerm_network_security_group.fe_nsg.id
  subnet_id                 = azurerm_subnet.frontend_subnet.id
}
resource "azurerm_subnet_network_security_group_association" "be_assoc" {
  network_security_group_id = azurerm_network_security_group.be_nsg.id
  subnet_id                 = azurerm_subnet.backend_subnet.id
}
