locals {
  prefix = "cmtr-6bbc5609-mod9"

  afw_name     = format("%s-afw", local.prefix)
  afw_pip_name = format("%s-pip", local.prefix)
  afw_rt_name  = format("%s-rt", local.prefix)

  app_rule_collection_name = "appRules"
  net_rule_collection_name = "netRules"
  nat_rule_collection_name = "natRules"
  default_route_name       = "egress-via-firewall"


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
      destination_ports     = ["80"]
      translated_port       = 80
      translated_address    = var.aks_private_ip
      destination_addresses = [var.aks_loadbalancer_ip]
      protocols             = ["TCP"]
    }
  ]
}
