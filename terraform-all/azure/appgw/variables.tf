variable "app_gateway_sku" {

  description = "The SKU of the Application Gateway."
  type        = string
  default     = "WAF_v2"
}
variable "app_gateway_tier" {

  description = "The tier of the Application Gateway."
  type        = string
  default     = "WAF_v2"

}
variable "app_gateway_subnet_id" {

  type = string

}
variable "backend_app_hostname" {

  type = string

}
variable "frontend_app_hostname" {

  type = string

}
variable "app_gateway_capacity" {

  description = "The capacity of the Application Gateway."
  type        = number
  default     = 2

}
variable "resource_prefix" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
}
