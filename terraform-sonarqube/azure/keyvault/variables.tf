variable "resource_prefix" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "key_permissions" {
  type    = list(string)
  default = ["Get", "List", "Update", "Delete", "Recover", "Backup", "Restore"]
}
variable "secret_permissions" {
  type    = list(string)
  default = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
}
variable "certificate_permissions" {
  type    = list(string)
  default = ["Get", "List", "Update", "Delete", "Recover", "Backup", "Restore"]
}
