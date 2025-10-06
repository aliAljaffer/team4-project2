variable "subscription_id" {
  type = string
}

variable "resource_prefix" {
  type    = string
  default = "team4-project2"
}

variable "rg_name" {
  type    = string
  default = "${var.resource_prefix}-rg"
}

variable "location" {
  type    = string
  default = "ukwest"
}

variable "fe_sunet_id" {
  type    = string
  
}

variable "be_sunet_id" {
  type    = string
  
}

variable "app_gw_ip" {
  type    = string
  
}