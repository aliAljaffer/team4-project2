resource "azurerm_public_ip" "appGW_public_ip" {
  name                = "${var.resource_prefix}-public-ip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "production"
  }
}

resource "azurerm_application_gateway" "appGW" {
  name                = "${var.resource_prefix}-appgw"
  location            = var.rg_location
  resource_group_name = var.rg_name

  sku {
    name     = var.app_gateway_sku
    tier     = var.app_gateway_tier
    capacity = var.app_gateway_capacity
  }
  gateway_ip_configuration {
    name      = "${var.resource_prefix}-appgw-ip-config"
    subnet_id = var.app_gateway_subnet_id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  # frontend_port {
  #   name = "${var.resource_prefix}-https-port"
  #   port = 443
  # }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appGW_public_ip.id
  }
  backend_address_pool {
    name  = "${local.backend_address_pool_name}-frontend"
    fqdns = [var.frontend_app_hostname]
  }
  backend_address_pool {
    name  = "${local.backend_address_pool_name}-backend"
    fqdns = [var.backend_app_hostname]
  }
  backend_http_settings {
    name                  = "${local.http_setting_name}-frontend"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 30
    probe_name            = local.frontend_probe_name
    host_name             = var.frontend_app_hostname
  }
  backend_http_settings {
    name                  = "${local.http_setting_name}-backend"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 30
    probe_name            = local.backend_probe_name
    host_name             = var.backend_app_hostname
  }
  probe {
    name                = local.frontend_probe_name
    protocol            = "Https"
    host                = var.frontend_app_hostname
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    name                = local.backend_probe_name
    protocol            = "Https"
    host                = var.backend_app_hostname
    path                = "/health"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
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
    priority                   = 100
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
      name                      = "${local.frontend_path_rule_name}-backend-api"
      paths                     = ["/api/*", "/health"]
      backend_address_pool_name = "${local.backend_address_pool_name}-backend"

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
  location            = var.rg_location
  resource_group_name = var.rg_name

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
  subnet_id                 = var.app_gateway_subnet_id
  network_security_group_id = azurerm_network_security_group.appGW_nsg.id


}
