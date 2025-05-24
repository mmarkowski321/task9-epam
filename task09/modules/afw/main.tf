resource "azurerm_public_ip" "afw_pip" { 
  name                = local.afw_pip_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_subnet" "afw_subnet" { 
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_firewall" "afw" { 
  name                = local.afw_name
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.afw_subnet.id
    public_ip_address_id = azurerm_public_ip.afw_pip.id
  }
}

resource "azurerm_route_table" "afw_rt" { 
  name                = local.afw_rt_name
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_route" "afw_default_route" { 
  name                   = local.default_route_name
  resource_group_name    = var.rg_name
  route_table_name       = azurerm_route_table.afw_rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "aks_snet_association" { 
  subnet_id      = var.aks_subnet_id
  route_table_id = azurerm_route_table.afw_rt.id
}

resource "azurerm_firewall_application_rule_collection" "app_rules" { 
  name                = local.app_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 100
  action              = "Allow"

  dynamic "rule" {
    for_each = local.app_rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns
      protocol {
        port = rule.value.port
        type = rule.value.type
      }
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "net_rules" {
  name                = local.net_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 200
  action              = "Allow"

  dynamic "rule" {
    for_each = local.net_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rules" {
  name                = local.nat_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 300
  action              = "Dnat"

  dynamic "rule" {
    for_each = local.nat_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
      protocols             = rule.value.protocols
    }
  }
}