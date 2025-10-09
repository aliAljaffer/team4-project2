output "vm_subnet_id" {
  value = azurerm_subnet.vm_subnet.id
}
output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "endpoint_subnet_id" {
  value = azurerm_subnet.endpoint_subnet.id
}

output "be_subnet_id" {
  value = azurerm_subnet.backend_subnet.id
}
output "fe_subnet_id" {
  value = azurerm_subnet.frontend_subnet.id
}
output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}
output "appgw_subnet_cidr" {
  value = azurerm_subnet.appgw_subnet.address_prefixes
}
output "fe_subnet_cidr" {
  value = azurerm_subnet.frontend_subnet.address_prefixes
}

