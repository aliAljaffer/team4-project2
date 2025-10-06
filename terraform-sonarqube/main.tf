module "rg" {
  source          = "./azure/resourcegroup"
  resource_prefix = var.resource_prefix
}
module "vnet" {
  source                  = "./azure/vnet"
  resource_group_name     = module.rg.name
  resource_group_location = module.rg.location
  resource_prefix         = var.resource_prefix
}

module "subnet" {
  source                  = "./azure/subnet"
  resource_group_name     = module.rg.name
  resource_group_location = module.rg.location
  vnet_name               = module.vnet.name
  resource_prefix         = var.resource_prefix
}
module "vm" {
  source                  = "./azure/vm"
  resource_group_name     = module.rg.name
  resource_group_location = module.rg.location
  subnet_id               = module.subnet.subnet_id
  admin_password          = var.admin_password
  admin_username          = var.admin_username
  resource_prefix         = var.resource_prefix

}
