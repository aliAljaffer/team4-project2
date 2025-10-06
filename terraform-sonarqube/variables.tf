variable "subscription_id" {
  type = string
}

variable "resource_prefix" {
  type    = string
  default = "team4-project2-sonarqube"
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "admin_username" {
  type      = string
  sensitive = true
}
