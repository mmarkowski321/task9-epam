module "afw" {
  source              = "./modules/afw"
  location            = var.location
  rg_name             = var.rg_name
  vnet_name           = var.vnet_name
  aks_subnet_id       = data.azurerm_subnet.aks_subnet.id
  aks_loadbalancer_ip = var.aks_loadbalancer_ip
  aks_private_ip      = var.aks_private_ip
}

data "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}
