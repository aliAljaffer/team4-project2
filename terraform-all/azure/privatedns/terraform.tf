resource "azurerm_private_dns_zone" "app_services_dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_services_link" {
  name                  = "${var.resource_prefix}-app-services-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.app_services_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}
