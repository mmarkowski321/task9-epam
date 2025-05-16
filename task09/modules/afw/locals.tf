locals {
  prefix = "cmtr-6bbc5609-mod9"

  afw_name     = "${local.prefix}-afw"
  afw_pip_name = "${local.prefix}-pip"
  afw_rt_name  = "${local.prefix}-rt"

  app_rule_collection_name = "${local.prefix}-app"
  net_rule_collection_name = "${local.prefix}-net"
  nat_rule_collection_name = "${local.prefix}-nat"
  default_route_name       = "${local.prefix}-egress"

  app_rules = [
    {
      name             = "AllowMicrosoftUpdates"
      source_addresses = ["*"]
      target_fqdns     = ["*.microsoft.com"]
      port             = 443
      type             = "Https"
    }
  ]

  net_rules = [
    {
      name                  = "AllowDNS"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
      protocols             = ["UDP"]
    }
  ]

  nat_rules = [
    {
      name                  = "nginx"
      source_addresses      = ["*"]
      destination_addresses = ["10.0.1.4"]
      destination_ports     = ["80"]
      translated_address    = var.aks_private_ip
      translated_port       = 80
      protocols             = ["TCP"]
    }
  ]
}
