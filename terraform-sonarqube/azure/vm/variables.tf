variable "resource_prefix" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "resource_group_location" {
  type = string
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "admin_username" {
  type      = string
  sensitive = true
}
variable "subnet_id" {
  type = string
}
