# Variables
# ------------------

# Locals
# ------------------

# Resources
# -----------------
resource "azurerm_virtual_network" "main_vnet" {
  # 10.0.0.0/16
  name                = "${var.resource_prefix}-vnet1"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  address_space = ["10.0.0.0/16"]

}

resource "azurerm_virtual_network" "sonarqube_vnet" {
  name                = "${var.resource_prefix}-vnet2"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  address_space = ["11.0.0.0/16"]

}
# Outputs
# -----------------

