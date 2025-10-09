resource "azurerm_private_dns_zone" "app_services_dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.main_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_services_link" {
  name                  = "${var.resource_prefix}-app-services-link"
  resource_group_name   = azurerm_resource_group.main_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_services_dns.name
  virtual_network_id    = azurerm_virtual_network.main_vnet.id
  registration_enabled  = false
}
