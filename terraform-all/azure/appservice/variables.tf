variable "resource_prefix" {
  type    = string
  default = "team4-project2"
}

variable "app_gw_ip" {
  type = string
}
variable "administrator_login" {
  type = string

  sensitive = true
}
variable "administrator_login_password" {
  type      = string
  sensitive = true
}
variable "instrumentation_key" {
  type      = string
  sensitive = true
}
variable "sql_database_name" {
  type = string
}
variable "db_fully_qualified_domain_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "endpoint_subnet_id" {
  type = string
}
variable "fe_subnet_id" {
  type = string
}
variable "be_subnet_id" {
  type = string
}
variable "db_driver" {
  type    = string
  default = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
}

variable "db_port" {
  type    = string
  default = "1433"
}
variable "fe_full_image_name" {
  type = string
}
variable "be_full_image_name" {
  type = string
}
variable "app_service_zone_id" {
  type = string
}
variable "app_gateway_id" {
  type = string
}
