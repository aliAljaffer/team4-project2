resource "azurerm_linux_web_app" "frontend_app" {
  name                          = local.frontend_app_name
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  service_plan_id               = azurerm_service_plan.fe_plan.id
  virtual_network_subnet_id     = var.fe_subnet_id
  public_network_access_enabled = false

  site_config {

    always_on = true
    application_stack {
      docker_image_name   = var.fe_full_image_name
      docker_registry_url = "https://index.docker.io"
    }
    health_check_path                 = "/"
    health_check_eviction_time_in_min = 5
  }


  app_settings = {
    VITE_API_BASE_URL                     = "http://${local.app_gateway_ip}"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = var.instrumentation_key
    #"APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.insights.connection_string
  }

  # lifecycle {
  #   ignore_changes = [site_config[0].application_stack[0].docker_image_name]
  # }
}

resource "azurerm_service_plan" "fe_plan" {
  name                = "${var.resource_prefix}-fe-plan"
  resource_group_name = var.rg_name
  location            = var.rg_location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "backend_app" {
  name                          = local.backend_app_name
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  service_plan_id               = azurerm_service_plan.be_plan.id
  virtual_network_subnet_id     = var.be_subnet_id
  public_network_access_enabled = false

  site_config {
    always_on = true
    cors {
      allowed_origins = [local.app_gateway_ip != null ? "http://${local.app_gateway_ip}" : "*"]
    }
    application_stack {
      docker_image_name   = var.be_full_image_name
      docker_registry_url = "https://index.docker.io"
    }
    health_check_path                 = "/api/health"
    health_check_eviction_time_in_min = 5
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = var.instrumentation_key
    #"APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.insights.connection_string
    # Azure SQL Database (Production)
    DB_HOST = var.db_fully_qualified_domain_name

    DB_PORT     = var.db_port
    DB_NAME     = var.sql_database_name
    DB_USERNAME = var.administrator_login
    DB_PASSWORD = var.administrator_login_password
    DB_DRIVER   = var.db_driver

    SPRING_PROFILES_ACTIVE = "azure"

    # Server Configuration
    SERVER_PORT = 8080

    # CORS Configuration
    CORS_ALLOWED_ORIGINS = "http://${local.app_gateway_ip},http://localhost:8080,http://localhost:5173"
  }

  # lifecycle {
  #   ignore_changes = [site_config[0].application_stack[0].docker_image_name]
  # }
}

resource "azurerm_service_plan" "be_plan" {
  name                = "${var.resource_prefix}-be-plan"
  resource_group_name = var.rg_name
  location            = var.rg_location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

# # VNet Integration
# resource "azurerm_app_service_virtual_network_swift_connection" "frontend_vnet_integration" {
#   app_service_id = azurerm_linux_web_app.frontend_app.id
#   subnet_id      = var.fe_subnet_id
# }

# resource "azurerm_app_service_virtual_network_swift_connection" "backend_vnet_integration" {
#   app_service_id = azurerm_linux_web_app.backend_app.id
#   subnet_id      = var.be_subnet_id
# }

# Private Endpoints
resource "azurerm_private_endpoint" "frontend_pe" {
  name                = "${local.frontend_app_name}-pe"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.endpoint_subnet_id

  private_service_connection {
    name                           = "${local.frontend_app_name}-psc"
    private_connection_resource_id = azurerm_linux_web_app.frontend_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${local.frontend_app_name}-dns"
    private_dns_zone_ids = [var.app_service_zone_id]
  }
}

resource "azurerm_private_endpoint" "backend_pe" {
  name                = "${local.backend_app_name}-pe"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.endpoint_subnet_id

  private_service_connection {
    name                           = "${local.backend_app_name}-psc"
    private_connection_resource_id = azurerm_linux_web_app.backend_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${local.backend_app_name}-dns"
    private_dns_zone_ids = [var.app_service_zone_id]
  }
}
