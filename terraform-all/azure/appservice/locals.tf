locals {
  frontend_app_name  = "${var.resource_prefix}-frontend"
  backend_app_name   = "${var.resource_prefix}-backend"
  dockerhub_username = "almusajin"
  app_gateway_ip     = var.app_gw_ip
}
