# Variables

variable "resource_prefix" {
  type    = string
  default = "team4-project2"
}

variable "rg_name" {
  type    = string
  default = "${var.resource_prefix}-rg"
}

variable "location" {
  type    = string
  default = "ukwest"
}

variable "fe_sunet_id" {
  type    = string
  
}

variable "be_sunet_id" {
  type    = string
  
}

variable "app_gw_ip" {
  type    = string
  
}
# ------------------

# Locals

locals {
  frontend_app_name = "${var.resource_prefix}-frontend"
  backend_app_name = "${var.resource_prefix}-backend"
  dockerhub_username = ""
}
# ------------------

# Resources

resource "azurerm_linux_web_app" "frontend_app" {
  name                = "${local.frontend_app_name}-frontend"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.fe_P1v3.id
  virtual_network_subnet_id = var.fe_sunet_id
  depends_on = [ var.fe_sunet_id, var.app_gw_ip ]

  site_config {
    
    always_on = true
    application_stack {
      docker_image_name     = "${local.dockerhub_username}/fe-image-project:latest"
      docker_registry_url = "https://index.docker.io"
    }
    health_check_path = "/"
    health_check_eviction_time_in_min = 5
  }
  
  app_settings = {
    REACT_APP_API_URL = "https://${app_gw_ip}/api"
  }
}

resource "azurerm_service_plan" "fe_P1v3" {
  name                = "${var.resource_prefix}-P1v3"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "backend_app" {
  name                = "${local.backend_app_name}-backend"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.be_P1v3.id
  virtual_network_subnet_id = var.be_sunet_id
  depends_on = [ var.be_sunet_id, var.app_gw_ip ]

  site_config {
    always_on = true
    cors {
      allowed_origins = ["https://${local.frontend_app_name}.azurewebsites.net"]
    }
    application_stack {
      docker_image_name     = "${local.dockerhub_username}/fe-image-project:latest"
      docker_registry_url = "https://index.docker.io"
    }
    health_check_path = "/health"
    health_check_eviction_time_in_min = 5
  }
  
  app_settings = { 
    # Azure SQL Database (Production)
    DB_HOST=your-server.database.windows.net
    DB_PORT=1433
    DB_NAME=burgerbuilder
    DB_USERNAME=your-username
    DB_PASSWORD=your-password
    DB_DRIVER=com.microsoft.sqlserver.jdbc.SQLServerDriver
    DB_ENCRYPT= true
    DB_TRUST_SERVER_CERTIFICATE= false
    DB_CONNECTION_TIMEOUT= 30000
    SPRING_PROFILES_ACTIVE= azure

    # Spring Profile - Set to 'azure' for Azure SQL, 'docker' for PostgreSQL
    SPRING_PROFILES_ACTIVE=azure

    # Server Configuration
    SERVER_PORT=8080

    # CORS Configuration
    CORS_ALLOWED_ORIGINS= "https://${local.backend_app_name}.azurewebsites.net"

    # Rate Limiting
    RATE_LIMIT_WINDOW_MS=900000
    RATE_LIMIT_MAX_REQUESTS=100



  }
}

resource "azurerm_service_plan" "be_P1v3" {
  name                = "${var.resource_prefix}-P1v3"
  resource_group_name = var.rg_name
  location            = var.location
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

output "app_gateway_public_ip" {
  value = azurerm_public_ip.app_gateway_public_ip.ip_address
}
# -----------------

