locals {
  backend_address_pool_name      = "${var.resource_prefix}-backend-pool"
  frontend_port_name             = "${var.resource_prefix}-frontend-port"
  frontend_ip_configuration_name = "${var.resource_prefix}-frontend-ip-config"
  http_setting_name              = "${var.resource_prefix}-http-setting"
  listener_name                  = "${var.resource_prefix}-listener"
  frontend_path_rule_name        = "${var.resource_prefix}-path-rule"
  redirect_configuration_name    = "${var.resource_prefix}-redirect-config"

  frontend_probe_name = "${var.resource_prefix}-frontend-probe"
  backend_probe_name  = "${var.resource_prefix}-backend-probe"

}
