resource "azurerm_network_security_group" "be_nsg" {
  name                = "${var.resource_prefix}-be-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name
  # SECURITY RULES HERE
  security_rule {
    name                       = "allow-api-from-appgw"
    protocol                   = "Tcp"
    source_address_prefixes    = var.subnet_appgw_cidr
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "allow-frontend-to-backend"
    protocol                   = "Tcp"
    source_address_prefixes    = var.subnet_fe_cidr
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 101
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "allow-backend-to-database"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["1433"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 200
    direction                  = "Outbound"
  }

  security_rule {
    name                       = "allow-agw-health-probe"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 102
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "deny-all-other-inbound"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
    access                     = "Deny"
    priority                   = 4096
    direction                  = "Inbound"
  }
}
resource "azurerm_network_security_group" "fe_nsg" {
  name                = "${var.resource_prefix}-fe-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name
  # SECURITY RULES HERE
  security_rule {
    name                       = "allow-http-from-appgw"
    protocol                   = "Tcp"
    source_address_prefixes    = var.subnet_appgw_cidr
    source_port_range          = "*"
    destination_port_range     = "80"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "allow-https-from-appgw"
    protocol                   = "Tcp"
    source_address_prefixes    = var.subnet_appgw_cidr
    source_port_range          = "*"
    destination_port_range     = "443"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 101
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "allow-agw-health-probe"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_port_range     = "80"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 102
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "deny-all-other-inbound"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
    access                     = "Deny"
    priority                   = 4096
    direction                  = "Inbound"
  }
}

resource "azurerm_subnet_network_security_group_association" "fe_assoc" {
  network_security_group_id = azurerm_network_security_group.fe_nsg.id
  subnet_id                 = var.fe_subnet_id
}
resource "azurerm_subnet_network_security_group_association" "be_assoc" {
  network_security_group_id = azurerm_network_security_group.be_nsg.id
  subnet_id                 = var.be_subnet_id
}
