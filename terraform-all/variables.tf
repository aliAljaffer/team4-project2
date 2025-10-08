variable "subscription_id" {
  type = string
}


variable "rg_name" {
  type = string

}

variable "location" {
  type    = string
  default = "ukwest"
}
variable "virtual_machine_name" {
  type    = string
  default = "test-vm"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}
variable "os_disk_name" {
  type    = string
  default = "my-test-disk"
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

  default = "team4"
}

variable "vm_disable_password_authentication" {
  type    = bool
  default = false
}
variable "vm_admin_password" {
  type = string
}





variable "db_host" {
  type = string

}

variable "db_name" {
  type = string

}

variable "db_port" {
  type    = string
  default = "1433"
}

variable "db_username" {
  type = string

}

variable "db_password" {
  type = string

}

variable "db_driver" {
  type    = string
  default = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
}
variable "admin_email" {
  description = "Email for alert notifications"
  type        = string
  default     = "your-email@example.com"
}
