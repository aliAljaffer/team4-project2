resource "azurerm_resource_group" "sq_rg" {
  name     = "${var.resource_prefix}-rg"
  location = "ukwest"
}
