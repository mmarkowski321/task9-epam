data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}
data "azurerm_subnet" "aks" {
  name                 = "aks-snet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.rg_name
}

resource "azurerm_subnet" "afw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "afw_pip" {
  name                = local.afw_pip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle { create_before_destroy = true }
}

resource "azurerm_firewall" "afw" {
  name                = local.afw_name
  resource_group_name = var.rg_name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "cfg"
    subnet_id            = azurerm_subnet.afw_subnet.id
    public_ip_address_id = azurerm_public_ip.afw_pip.id
  }
}

resource "azurerm_route_table" "afw_rt" {
  name                          = local.afw_rt_name
  resource_group_name           = var.rg_name
  location                      = var.location
  bgp_route_propagation_enabled = false

  route {
    name                   = "egress-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = data.azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.afw_rt.id
}

resource "azurerm_firewall_application_rule_collection" "app_rules" {
  name                = "appRules"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name             = "AllowAKSEgressFQDN"
    source_addresses = ["*"]
    target_fqdns     = ["AzureKubernetesService"]
    protocol {
      type = "Https"
      port = 443
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "net_rules" {
  name                = "netRules"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 200
  action              = "Allow"

  rule {
    name                  = "AllowDNS"
    source_addresses      = ["*"]
    destination_addresses = ["*"]
    destination_ports     = ["53"]
    protocols             = ["UDP"]
  }

  rule {
    name                  = "AllowHTTPIn"
    source_addresses      = ["*"]
    destination_addresses = [azurerm_public_ip.afw_pip.ip_address]
    destination_ports     = ["80"]
    protocols             = ["TCP"]
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rules" {
  name                = "natRules"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 300
  action              = "Dnat"

  rule {
    name                  = "nginx"
    source_addresses      = ["*"]
    destination_addresses = [azurerm_public_ip.afw_pip.ip_address]
    destination_ports     = ["80"]
    translated_address    = var.aks_private_ip
    translated_port       = 80
    protocols             = ["TCP"]
  }
}
