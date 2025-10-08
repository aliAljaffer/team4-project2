# Variables
# ------------------
variable "sql_admin_username" {
  type        = string
  default     = "blalalalalabalala"
  description = "the username for the SQL admin"
  sensitive   = true
}
variable "sql_admin_password" {
  type        = string
  description = "the password for the SQL admin"
  sensitive   = true
}

variable "sql_database_name" {
  type        = string
  default     = "project2db"
  description = "the name of the database"
}

variable "sql_server_version" {
  type        = string
  default     = "12.0"
  description = "the version of the SQL server"

}


# Locals
# ------------------
locals {
  sql_server_name = "${var.resource_prefix}-sqlserver"
}




# Resources
# -----------------

resource "azurerm_mssql_server" "sql_server" {
  name                         = local.sql_server_name
  location                     = azurerm_resource_group.main_rg.location
  resource_group_name          = azurerm_resource_group.main_rg.name
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  public_network_access_enabled = false

  tags = {
    environment = "production"
    tier        = "database"
  }
}

resource "azurerm_mssql_database" "sql_database" {
  name        = var.sql_database_name
  server_id   = azurerm_mssql_server.sql_server.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name    = "GP_Gen5_2"
  max_size_gb = 30

  tags = {
    environment = "production"
    tier        = "database"
  }
}

resource "azurerm_private_dns_zone" "sql_private_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.main_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_main_vnet" {
  name                  = "${var.resource_prefix}-sql-private-dns-link"
  resource_group_name   = azurerm_resource_group.main_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_private_dns.name
  virtual_network_id    = azurerm_virtual_network.main_vnet.id
  registration_enabled  = false

}

resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = "${var.resource_prefix}-sql-private-endpoint"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  subnet_id           = azurerm_subnet.db_subnet.id


  private_dns_zone_group {
    name                 = "${var.resource_prefix}-sql-privatednsgroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_private_dns.id]
  }
  private_service_connection {
    name                           = "${var.resource_prefix}-sql-privatesc"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.sql_main_vnet]
  tags = {
    environment = "production"
    tier        = "database"
  }
}
resource "azurerm_network_security_group" "sql_nsg" {
  name                = "${var.resource_prefix}-sql-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "AllowSQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = one(azurerm_virtual_network.main_vnet.address_space)
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
    tier        = "database"
  }

}
resource "azurerm_subnet_network_security_group_association" "sql_nsg_association" {
  network_security_group_id = azurerm_network_security_group.sql_nsg.id
  subnet_id                 = azurerm_subnet.db_subnet.id

}



# Outputs
# -----------------

output "sql_server_name" {
  description = "The name of the SQL server"
  sensitive   = false
  value       = azurerm_mssql_server.sql_server.name
}
output "sql_database_name" {
  description = "The name of the SQL database"
  sensitive   = false
  value       = azurerm_mssql_database.sql_database.name

}
output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL server"
  sensitive   = false
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
