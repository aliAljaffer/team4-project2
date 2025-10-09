variable "autoscale_cpu_threshold_high" {
  type    = number
  default = 60
}

variable "autoscale_cpu_threshold_low" {
  type    = number
  default = 30
}
variable "resource_prefix" {
  type = string
}
variable "admin_email" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "fe_sp_id" {
  type = string
}
variable "be_sp_id" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "frontend_app_id" {
  type = string
}
variable "backend_app_id" {
  type = string
}
variable "app_gateway_id" {
  type = string
}
