variable "resource_prefix" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
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
variable "admin_username" {

  type = string
}

variable "vm_disable_password_authentication" {
  type    = bool
  default = false
}
variable "admin_password" {
  type = string
}
variable "vm_subnet_id" {
  type = string
}
