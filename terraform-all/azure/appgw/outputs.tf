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
