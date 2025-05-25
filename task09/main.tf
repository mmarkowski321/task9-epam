module "afw" {
  source = "./modules/afw"

  resource_group_name = local.rg_name
  location            = var.location
  vnet_name           = local.vnet_name
  aks_subnet_name     = var.aks_subnet_name
  aks_subnet_prefix   = var.aks_subnet_prefix
  afw_subnet_name     = local.afw_subnet_name
  afw_subnet_prefix   = local.afw_subnet_prefix
  firewall_name       = local.firewall_name
  public_ip_name      = local.firewall_public_ip_name
  route_table_name    = local.route_table_name
  aks_loadbalancer_ip = var.aks_loadbalancer_ip
  name_prefix         = var.name_prefix

}
