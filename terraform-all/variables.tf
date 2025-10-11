variable "subscription_id" {
  type    = string
  default = "baddefault"
}

variable "resource_prefix" {
  type    = string
  default = "team4-project2"
}

variable "rg_name" {
  type = string

  default = "baddefault"
}

variable "location" {
  type    = string
}

variable "sql_admin_username" {
  type      = string
  sensitive = true
}
variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "admin_email" {
  description = "Email for alert notifications"
  type        = string
  default     = "your-email@example.com"
}

variable "admin_password" {
  description = "VM admin password"
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
  sensitive   = true
}
variable "be_full_image_name" {
  type    = string
  default = "almusajin/ecommerce-backend:latest"
}
variable "fe_full_image_name" {
  type    = string
  default = "almusajin/ecommerce-frontend:latest"
}

variable "backend_health_path" {
  type        = string
  description = "Path to the backend's health check, starts with /"
  default     = "/api/health"
}

