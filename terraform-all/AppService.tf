# Variables

variable "resource_prefix" {
  type    = string
  default = "team4-project2"
}

# variable "fe_sunet_id" {
#   type = string

# }

# variable "be_sunet_id" {
#   type = string
# }

# variable "app_gw_ip" {
#   type = string
# }
# ------------------

# Locals

locals {
  frontend_app_name  = "${var.resource_prefix}-frontend"
  backend_app_name   = "${var.resource_prefix}-backend"
  dockerhub_username = "almusajin"
  app_gateway_ip     = azurerm_public_ip.appGW_public_ip.ip_address
}
# ------------------

# Resources

resource "azurerm_linux_web_app" "frontend_app" {
  name                      = "${local.frontend_app_name}-frontend"
  resource_group_name       = azurerm_resource_group.main_rg.name
  location                  = azurerm_resource_group.main_rg.location
  service_plan_id           = azurerm_service_plan.fe_plan.id
  virtual_network_subnet_id = azurerm_subnet.frontend_subnet.id

  site_config {

    always_on = true
    application_stack {
      docker_image_name   = "${local.dockerhub_username}/ecommerce-frontend:latest"
      docker_registry_url = "https://index.docker.io"
    }
    health_check_path                 = "/"
    health_check_eviction_time_in_min = 5
  }


  app_settings = {
    REACT_APP_API_URL                     = "https://${local.app_gateway_ip}/api"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = azurerm_application_insights.insights.instrumentation_key
    #"APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.insights.connection_string
  }
}

resource "azurerm_service_plan" "fe_plan" {
  name                = "${var.resource_prefix}-fe-plan"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "backend_app" {
  name                      = "${local.backend_app_name}-backend"
  resource_group_name       = azurerm_resource_group.main_rg.name
  location                  = azurerm_resource_group.main_rg.location
  service_plan_id           = azurerm_service_plan.be_plan.id
  virtual_network_subnet_id = azurerm_subnet.backend_subnet.id

  site_config {
    always_on = true
    cors {
      allowed_origins = ["https://${local.app_gateway_ip}"]
    }
    application_stack {
      docker_image_name   = "${local.dockerhub_username}/ecommerce-backend:latest"
      docker_registry_url = "https://index.docker.io"
    }
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 5
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.insights.instrumentation_key
    #"APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.insights.connection_string
    # Azure SQL Database (Production)
    DB_HOST                     = azurerm_mssql_server.sql_server.fully_qualified_domain_name
    DB_PORT                     = var.db_port
    DB_NAME                     = azurerm_mssql_database.sql_database.name
    DB_USERNAME                 = azurerm_mssql_server.sql_server.administrator_login
    DB_PASSWORD                 = azurerm_mssql_server.sql_server.administrator_login_password
    DB_DRIVER                   = var.db_driver
    DB_ENCRYPT                  = true
    DB_TRUST_SERVER_CERTIFICATE = false
    DB_CONNECTION_TIMEOUT       = 30000

    # Spring Profile - Set to 'azure' for Azure SQL, 'docker' for PostgreSQL
    SPRING_PROFILES_ACTIVE = "azure"

    # Server Configuration
    SERVER_PORT = 8080

    # CORS Configuration
    CORS_ALLOWED_ORIGINS = "https://${local.app_gateway_ip}"

    # Rate Limiting
    RATE_LIMIT_WINDOW_MS    = 900000
    RATE_LIMIT_MAX_REQUESTS = 100



  }
}

resource "azurerm_service_plan" "be_plan" {
  name                = "${var.resource_prefix}-be-plan"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}
# -----------------

# Outputs

output "frontend_app_hostname" {
  value = azurerm_linux_web_app.frontend_app.default_hostname
}

output "backend_app_hostname" {
  value = azurerm_linux_web_app.backend_app.default_hostname
}
# -----------------

