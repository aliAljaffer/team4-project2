variable "subscription_id" {
  type    = string
  default = "baddefault"
}


variable "rg_name" {
  type = string

  default = "baddefault"
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
  default = "Standard_D2s_v3"
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

  default = "0001-com-ubuntu-server-jammy"
}

variable "source_image_reference_sku" {

  type = string

  default = "22_04-lts-gen2"
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
  type    = string
  default = "baddefault"
}





variable "db_host" {
  type = string

  default = "baddefault"
}

variable "db_name" {
  type = string

  default = "baddefault"
}

variable "db_port" {
  type    = string
  default = "1433"
}

variable "db_username" {
  type = string

  default = "baddefault"
}

variable "db_password" {
  type = string

  default = "baddefault"
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
