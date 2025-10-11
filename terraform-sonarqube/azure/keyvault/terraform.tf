resource "azurerm_key_vault" "kvault" {
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  name                          = "${var.resource_prefix}-13ov8-kv"
  sku_name                      = "standard"
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment        = true
  public_network_access_enabled = true
  rbac_authorization_enabled    = false
  access_policy {
    object_id = data.azurerm_client_config.current.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id

    key_permissions         = var.key_permissions
    secret_permissions      = var.secret_permissions
    certificate_permissions = var.certificate_permissions
  }
}

data "azurerm_client_config" "current" {}
