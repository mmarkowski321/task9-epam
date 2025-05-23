locals {
  prefix    = "cmtr-6bbc5609-mod9"
  rg_name   = format("%s-rg", local.prefix)
  vnet_name = format("%s-vnet", local.prefix)
  location  = "East US"
}