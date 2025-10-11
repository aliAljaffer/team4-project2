output "agw_ip" {
  value = {
    frontend = "http://${module.agw.app_gateway_public_ip}/"
    backend  = "http://${module.agw.app_gateway_public_ip}${var.backend_health_path}"
  }
  description = "IP of the Application Gateway"
}
