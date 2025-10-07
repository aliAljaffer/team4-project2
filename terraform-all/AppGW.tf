# Variables
# ------------------
variable "app_gateway_sku" {

  description = "The SKU of the Application Gateway."
  type        = string
  default     = "WAF_v2"
}
variable "app_gateway_tier" {

  description = "The tier of the Application Gateway."
  type        = string
  default     = "WAF v2"

}
variable "app_gateway_capacity" {

  description = "The capacity of the Application Gateway."
  type        = number
  default     = 2

}


# Locals
# ------------------

locals {
  backend_address_pool_name      = "${var.resource_prefix}-backend-pool"
  frontend_port_name             = "${var.resource_prefix}-frontend-port"
  frontend_ip_configuration_name = "${var.resource_prefix}-frontend-ip-config"
  http_setting_name              = "${var.resource_prefix}-http-setting"
  listener_name                  = "${var.resource_prefix}-listener"
  frontend_path_rule_name        = "${var.resource_prefix}-path-rule"
  redirect_configuration_name    = "${var.resource_prefix}-redirect-config"

  frontend_probe_name = "${var.resource_prefix}-frontend-probe"
  backend_probe_name  = "${var.resource_prefix}-backend-probe"

}


# Resources
# -----------------
resource "azurerm_public_ip" "appGW_public_ip" {
  name                = "${var.resource_prefix}-public-ip"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "production"
  }
}

resource "azurerm_application_gateway" "appGW" {
  name                = "${var.resource_prefix}-appgw"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  sku {
    name     = var.app_gateway_sku
    tier     = var.app_gateway_tier
    capacity = var.app_gateway_capacity
  }
  gateway_ip_configuration {
    name      = "${var.resource_prefix}-appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  frontend_port {
    name = "${var.resource_prefix}-https-port"
    port = 443
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appGW_public_ip.id
  }
  backend_address_pool {
    name = "${local.backend_address_pool_name}-frontend"
  }
  backend_address_pool {
    name = "${local.backend_address_pool_name}-backend"
  }
  backend_http_settings {
    name                  = "${local.http_setting_name}-frontend"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30

    probe_name = local.frontend_probe_name
  }
  backend_http_settings {
    name                  = "${local.http_setting_name}-backend"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30

    probe_name = local.backend_probe_name
  }
  probe {
    name                = local.frontend_probe_name
    protocol            = "Http"
    host                = "localhost"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200"]
    }
  }
  probe {
    name                = local.backend_probe_name
    protocol            = "Http"
    host                = "localhost"
    path                = "/health"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200"]
    }
  }
  http_listener {
    name                           = "${local.listener_name}-http"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = "${local.frontend_path_rule_name}-http-rule"
    rule_type                  = "PathBasedRouting"
    http_listener_name         = "${local.listener_name}-http"
    backend_address_pool_name  = "${local.backend_address_pool_name}-frontend"
    backend_http_settings_name = "${local.http_setting_name}-frontend"
    url_path_map_name          = "${var.resource_prefix}-url-path-map"
  }
  url_path_map {
    name                               = "${var.resource_prefix}-url-path-map"
    default_backend_address_pool_name  = "${local.backend_address_pool_name}-frontend"
    default_backend_http_settings_name = "${local.http_setting_name}-frontend"
    path_rule {
      name                       = "${local.frontend_path_rule_name}-backend-api"
      paths                      = ["/api/*"]
      backend_address_pool_name  = "${local.backend_address_pool_name}-backend"
      backend_http_settings_name = "${local.http_setting_name}-backend"
    }
    path_rule {
      name                       = "${local.frontend_path_rule_name}-frontend-root"
      paths                      = ["/*"]
      backend_address_pool_name  = "${local.backend_address_pool_name}-frontend"
      backend_http_settings_name = "${local.http_setting_name}-frontend"
    }
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"


  }
  tags = {
    environment = "production"
  }
}

resource "azurerm_network_security_group" "appGW_nsg" {
  name                = "${var.resource_prefix}-appgw-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-AppGW-manager"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }

}
resource "azurerm_subnet_network_security_group_association" "appGW_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.appgw_subnet.id
  network_security_group_id = azurerm_network_security_group.appGW_nsg.id


}


# Outputs
# -----------------

output "app_gateway_public_ip" {
  description = "The public IP address of the Application Gateway."
  value       = azurerm_public_ip.appGW_public_ip.ip_address

}
output "app_gateway_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.appGW.id

}
output "app_gateway_name" {
  description = "The name of the Application Gateway."
  value       = azurerm_application_gateway.appGW.name

}
