module "rg" {
  source          = "./azure/resourcegroup"
  resource_prefix = var.resource_prefix
}

module "vnet" {
  source          = "./azure/vnet"
  resource_prefix = var.resource_prefix
  rg_location     = module.rg.rg_location
  rg_name         = module.rg.rg_name
}

module "subnet" {
  source          = "./azure/subnet"
  resource_prefix = var.resource_prefix
  rg_location     = module.rg.rg_location
  rg_name         = module.rg.rg_name
  vnet_name       = module.vnet.vnet_name
}

module "vm" {
  source          = "./azure/vm"
  resource_prefix = var.resource_prefix
  rg_location     = module.rg.rg_location
  rg_name         = module.rg.rg_name
  vm_subnet_id    = module.subnet.vm_subnet_id
  admin_password  = var.admin_password
  admin_username  = var.admin_username
}

module "db" {
  source             = "./azure/db"
  resource_prefix    = var.resource_prefix
  rg_location        = module.rg.rg_location
  rg_name            = module.rg.rg_name
  vnet_id            = module.vnet.vnet_id
  db_subnet_id       = module.subnet.db_subnet_id
  sql_admin_username = var.sql_admin_username
  sql_admin_password = var.sql_admin_password
  vnet_address_space = module.vnet.vnet_address_space
}

module "pdns" {
  source          = "./azure/privatedns"
  resource_prefix = var.resource_prefix
  rg_location     = module.rg.rg_location
  rg_name         = module.rg.rg_name
  vnet_id         = module.vnet.vnet_id
}
module "nsg" {
  source            = "./azure/nsg"
  resource_prefix   = var.resource_prefix
  rg_location       = module.rg.rg_location
  rg_name           = module.rg.rg_name
  fe_subnet_id      = module.subnet.fe_subnet_id
  be_subnet_id      = module.subnet.be_subnet_id
  subnet_appgw_cidr = module.subnet.appgw_subnet_cidr
  subnet_fe_cidr    = module.subnet.fe_subnet_cidr
}
module "agw" {
  source                = "./azure/appgw"
  resource_prefix       = var.resource_prefix
  rg_location           = module.rg.rg_location
  rg_name               = module.rg.rg_name
  app_gateway_subnet_id = module.subnet.appgw_subnet_id
  backend_app_hostname  = module.appservices.backend_app_hostname
  frontend_app_hostname = module.appservices.frontend_app_hostname
}
module "appservices" {
  source                         = "./azure/appservice"
  resource_prefix                = var.resource_prefix
  rg_location                    = module.rg.rg_location
  rg_name                        = module.rg.rg_name
  be_subnet_id                   = module.subnet.be_subnet_id
  fe_subnet_id                   = module.subnet.fe_subnet_id
  db_fully_qualified_domain_name = module.db.sql_server_fqdn
  administrator_login            = var.sql_admin_username
  administrator_login_password   = var.sql_admin_password
  app_gw_ip                      = module.agw.app_gateway_public_ip
  endpoint_subnet_id             = module.subnet.endpoint_subnet_id
  sql_database_name              = module.db.sql_database_name
  instrumentation_key            = module.monitoring.instrumentation_key
  fe_full_image_name             = var.fe_full_image_name
  be_full_image_name             = var.be_full_image_name
  app_gateway_id                 = module.agw.app_gateway_id
  app_service_zone_id            = module.pdns.app_service_zone_id
  appgw_subnet_id                = module.subnet.appgw_subnet_id
}

module "monitoring" {
  source          = "./azure/monitoring"
  resource_prefix = var.resource_prefix
  rg_location     = module.rg.rg_location
  rg_name         = module.rg.rg_name
  admin_email     = var.admin_email
  be_sp_id        = module.appservices.be_sp_id
  fe_sp_id        = module.appservices.fe_sp_id
  frontend_app_id = module.appservices.frontend_app_id
  backend_app_id  = module.appservices.backend_app_id
  app_gateway_id  = module.agw.app_gateway_id
  sql_server_id   = module.db.sql_server_id
}

