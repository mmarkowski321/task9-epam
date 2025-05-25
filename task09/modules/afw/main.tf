data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "firewall" {
  name                 = var.afw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = [var.afw_subnet_prefix]


}

resource "azurerm_public_ip" "firewall" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "this" {
  name                = var.firewall_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_route_table" "this" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name                   = local.route_name
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.this.ip_configuration[0].private_ip_address
  }

  route {
    name           = "AKSManagementRoute"
    address_prefix = "AzureCloud.WestEurope"
    next_hop_type  = "Internet"
  }

  bgp_route_propagation_enabled = false
}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = data.azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.this.id
}

resource "azurerm_firewall_application_rule_collection" "app" {
  name                = local.app_rule_name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 300
  action              = "Allow"
  rule {
    name             = "AllowAKSOutbound"
    source_addresses = ["*"]
    target_fqdns     = local.app_rule_fqdns

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }

}

resource "azurerm_firewall_network_rule_collection" "net" {
  name                = local.net_rule_name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  dynamic "rule" {
    for_each = local.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat" {
  name                = local.nat_rule_name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "http-dnat"
    source_addresses      = ["*"]
    destination_addresses = [azurerm_public_ip.firewall.ip_address]
    destination_ports     = ["80"]
    translated_address    = var.aks_loadbalancer_ip
    translated_port       = "80"
    protocols             = ["TCP"]
  }
  rule {
    name                  = "https-dnat"
    source_addresses      = ["*"]
    destination_addresses = [azurerm_public_ip.firewall.ip_address]
    destination_ports     = ["443"]
    translated_address    = var.aks_loadbalancer_ip
    translated_port       = "443"
    protocols             = ["TCP"]
  }
}
