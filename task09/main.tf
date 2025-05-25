data "azurerm_subnet" "aks" {
  name                 = "aks-snet"
  virtual_network_name = local.vnet_name
  resource_group_name  = local.rg_name
}

module "afw" {
  source              = "./modules/afw"
  rg_name             = local.rg_name
  location            = local.location
  vnet_name           = local.vnet_name
  aks_subnet_id       = data.azurerm_subnet.aks.id
  aks_loadbalancer_ip = var.aks_loadbalancer_ip
  aks_private_ip      = var.aks_private_ip
}
