variable "subnet_appgw_cidr" {
  type        = list(string)
  description = "CIDR range of Application Gateway subnet"
}

variable "subnet_fe_cidr" {
  type        = list(string)
  description = "CIDR range of Frontend subnet"
}

variable "subnet_be_cidr" {
  type        = list(string)
  description = "CIDR range of Backend subnet"
}

variable "subnet_db_cidr" {
  type        = list(string)
  description = "CIDR range of Database subnet"
}

# Locals for NSG names
locals {
  fe_nsg_name = "${var.resource_prefix}-fe-nsg"
  be_nsg_name = "${var.resource_prefix}-be-nsg"
}

# Frontend App Service NSG
resource "azurerm_network_security_group" "nsg_fe" {
  name                = local.fe_nsg_name
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

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

  tags = {
    environment = "production"
    tier        = "frontend"
  }
}

# Backend App Service NSG
resource "azurerm_network_security_group" "nsg_be" {
  name                = local.be_nsg_name
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "allow-api-from-appgw"
    protocol                   = "Tcp"
    source_address_prefixes    = var.subnet_appgw_cidr
    source_port_range          = "*"
    destination_port_range     = "8080"
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
    destination_port_range     = "8080"
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
    destination_port_range     = "8080"
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

  tags = {
    environment = "production"
    tier        = "backend"
  }
}

# Subnet Associations
resource "azurerm_subnet_network_security_group_association" "fe_nsg_assoc" {
  subnet_id                 = azurerm_subnet.frontend_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_fe.id
}

resource "azurerm_subnet_network_security_group_association" "be_nsg_assoc" {
  subnet_id                 = azurerm_subnet.backend_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_be.id
}
