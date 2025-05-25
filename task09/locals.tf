locals {
  name_prefix             = var.name_prefix
  firewall_public_ip_name = format("%s-pip", local.name_prefix)
  rg_name                 = format("%s-rg", local.name_prefix)
  afw_subnet_prefix       = "10.0.1.0/24"
  firewall_name           = format("%s-afw", local.name_prefix)
  route_table_name        = format("%s-rt", local.name_prefix)
  app_rule_name           = format("%s-allow-mcr", var.name_prefix)
  vnet_name               = format("%s-vnet", local.name_prefix)
  afw_subnet_name         = "AzureFirewallSubnet"


}
