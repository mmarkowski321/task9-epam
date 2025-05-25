locals {
  vnet          = data.azurerm_virtual_network.vnet
  app_rule_name = format("%s-allow-mcr", var.name_prefix)
  net_rule_name = format("%s-net", var.name_prefix)
  nat_rule_name = format("%s-nat", var.name_prefix)
  route_name    = format("%s-default", var.name_prefix)

  network_rules = [
    {
      name                  = "AllowDNS"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
      protocols             = ["UDP", "TCP"]
    },
    {
      name                  = "AllowAzureCloud"
      source_addresses      = ["*"]
      destination_addresses = ["AzureCloud"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    },
    {
      name                  = "AllowAKSEgress"
      source_addresses      = ["10.0.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    },
    {
      name                  = "AllowAKSCommunication"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["22", "443", "9000", "1194"]
      protocols             = ["TCP", "UDP"]
    },
    {
      name                  = "AllowHTTPOutbound"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["80", "443"]
      protocols             = ["TCP"]
    },
    {
      name                  = "AllowNTP"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
      protocols             = ["UDP"]
    }
  ]
  app_rule_fqdns = [
    "*.hcp.northeurope.azmk8s.io",
    "*.tun.northeurope.azmk8s.io",
    "aks-engine-fqdn.northeurope.cloudapp.azure.com",

    "*.aks-ingress.microsoft.com",
    "*.aks.microsoft.com",
    "*.login.microsoft.com",
    "*.monitoring.azure.com",
    "*.azurecr.io",
    "*.data.mcr.microsoft.com",
    "*.blob.core.windows.net",
    "mcr.microsoft.com",
    "*.cdn.mscr.io",
    "management.azure.com",
    "login.microsoftonline.com",

    "*.kubernetes.io",
    "kubernetes.io",
    "k8s.gcr.io",
    "storage.googleapis.com",
    "security.ubuntu.com",
    "packages.microsoft.com",
    "azure.archive.ubuntu.com",
    "motd.ubuntu.com",

    "dc.services.visualstudio.com",
    "*.opinsights.azure.com",
    "*.monitoring.azure.com",
    "prometheus.monitor.azure.com",

    "checkip.dyndns.org",
    "api.snapcraft.io",
    "graph.microsoft.com",
    "*.api.azurecr.io",
    "*.teleport.azure.com",
    "*.ubuntu.com"
  ]

}
