variable "resource_prefix" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "be_subnet_id" {
  type = string
}
variable "fe_subnet_id" {
  type = string
}
variable "subnet_appgw_cidr" {
  type = set(string)
}
variable "subnet_fe_cidr" {
  type = set(string)
}
