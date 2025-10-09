output "frontend_app_hostname" {
  value = azurerm_linux_web_app.frontend_app.default_hostname
}
output "frontend_app_id" {
  value = azurerm_linux_web_app.frontend_app.id
}
output "be_sp_id" {
  value = azurerm_service_plan.be_plan.id
}
output "fe_sp_id" {
  value = azurerm_service_plan.fe_plan.id
}
output "backend_app_hostname" {
  value = azurerm_linux_web_app.backend_app.default_hostname
}
output "backend_app_id" {
  value = azurerm_linux_web_app.backend_app.id
}

output "frontend_private_endpoint_ip" {
  value = azurerm_private_endpoint.frontend_pe.private_service_connection[0].private_ip_address
}

output "backend_private_endpoint_ip" {
  value = azurerm_private_endpoint.backend_pe.private_service_connection[0].private_ip_address
}
