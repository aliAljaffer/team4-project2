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
  service_endpoints    = ["Microsoft.Web"]

}
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "${var.resource_prefix}-frontend-subnet"
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["10.0.2.0/24"]
  delegation {
    name = "Microsoft.Web.serverFarms"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
resource "azurerm_subnet" "backend_subnet" {
  name                 = "${var.resource_prefix}-backend-subnet"
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["10.0.3.0/24"]
  delegation {
    name = "Microsoft.Web.serverFarms"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
resource "azurerm_subnet" "db_subnet" {
  name                              = "${var.resource_prefix}-db-subnet"
  virtual_network_name              = azurerm_virtual_network.main_vnet.name
  resource_group_name               = azurerm_resource_group.main_rg.name
  address_prefixes                  = ["10.0.4.0/24"]
  service_endpoints                 = ["Microsoft.Sql"]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "${var.resource_prefix}-vm-subnet"
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  resource_group_name  = azurerm_resource_group.main_rg.name
  address_prefixes     = ["10.0.20.0/24"]
}

resource "azurerm_subnet" "endpoint_subnet" {
  name                 = "${var.resource_prefix}-endpoint-subnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.8.0/24"]
}

# Outputs
# -----------------

