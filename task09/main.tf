data "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.rg_name
}

module "afw" {
  source              = "./modules/afw"
  location            = local.location
  rg_name             = local.rg_name
  vnet_name           = local.vnet_name
  aks_subnet_id       = data.azurerm_subnet.aks_subnet.id
  aks_loadbalancer_ip = var.aks_loadbalancer_ip
  aks_private_ip      = var.aks_private_ip
}