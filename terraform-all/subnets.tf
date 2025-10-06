# Variables
# ------------------

# Locals
# ------------------

# Resources
# -----------------
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "${var.resource_prefix}-appgw-subnet"
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "${var.resource_prefix}-frontend-subnet"
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "backend_subnet" {
  name                 = "${var.resource_prefix}-backend-subnet"
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["10.0.3.0/24"]
}
resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.resource_prefix}-db-subnet"
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["10.0.4.0/24"]
}
resource "azurerm_subnet" "sqube_subnet" {
  name                 = "${var.resource_prefix}-sqube-subnet"
  virtual_network_name = azurerm_virtual_network.sonarqube_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["11.0.1.0/24"]
}
# Outputs
# -----------------

