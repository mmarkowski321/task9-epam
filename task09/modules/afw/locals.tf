locals {
  prefix = "cmtr-6bbc5609-mod9"

  afw_name     = format("%s-afw", local.prefix)
  afw_pip_name = format("%s-pip", local.prefix)
  afw_rt_name  = format("%s-rt", local.prefix)

  app_rule_collection_name = format("%s-app", local.prefix)
  net_rule_collection_name = format("%s-net", local.prefix)
  nat_rule_collection_name = format("%s-nat", local.prefix)
  default_route_name       = format("%s-egress", local.prefix)

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
