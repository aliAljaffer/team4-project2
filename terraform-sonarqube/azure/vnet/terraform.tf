
resource "azurerm_virtual_network" "sq_vnet" {
  name                = local.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["11.0.0.0/16"]
}
