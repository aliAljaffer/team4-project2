output "fe_autoscale_id" {
  description = "Frontend Autoscale Setting ID"
  value       = azurerm_monitor_autoscale_setting.fe_autoscale.id
}

output "be_autoscale_id" {
  description = "Backend Autoscale Setting ID"
  value       = azurerm_monitor_autoscale_setting.be_autoscale.id
}

output "app_id" {
  value = azurerm_application_insights.insights.app_id
}
output "instrumentation_key" {
  value = azurerm_application_insights.insights.instrumentation_key
}
