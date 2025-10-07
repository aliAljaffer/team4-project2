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
variable "virtual_machine_name" {
  type = string
}

variable "disksize" {
  type    = string
  default = "Standard_DS1_v2"
}
variable "os_disk_name" {

  type = string
}
variable "os_disk_caching" {

  type    = string
  default = "ReadWrite"
}

variable "os_disk_storage_account_type" {

  type    = string
  default = "Standard_LRS"
}

variable "source_image_reference_publisher" {

  type = string

  default = "Canonical"
}

variable "source_image_reference_offer" {

  type = string

  default = "UbuntuServer"
}

variable "source_image_reference_sku" {

  type = string

  default = "22.04-LTS"
}

variable "source_image_reference_version" {

  type = string

  default = "latest"
}
variable "vm_admin_username" {

  type = string

  default = "azureuser"
}

variable "vm_disable_password_authentication" {

  type = bool

  default = false
}
variable "vm_admin_password" {
  type = string
}
variable "fe_sunet_id" {
  type = string

}

variable "be_sunet_id" {
  type = string

}

variable "app_gw_ip" {
  type = string

}

variable "db_host" {
  type = string

}

variable "db_name" {
  type = string

}

variable "db_port" {
  type = string

}

variable "db_username" {
  type = string

}

variable "db_password" {
  type = string

}

variable "db_driver" {
  type = string

}
