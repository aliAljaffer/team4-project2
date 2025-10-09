variable "subscription_id" {
  type = string
}

variable "resource_prefix" {
  type    = string
  default = "team4-p2-sqube"
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "NEW_ADMIN_PASSWORD" {
  type      = string
  sensitive = true
}
variable "admin_username" {
  type      = string
  sensitive = true
}
