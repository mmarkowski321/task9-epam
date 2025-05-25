variable "name_prefix" {
  description = "Common prefix (e.g. cmtr-6bbc5609-mod9) used to generate all resource names"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing Resource Group where Azure Firewall resources will be deployed"
  type        = string
}

variable "location" {
  description = "Azure region (e.g. East US) in which to create the firewall and related resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the existing Virtual Network containing both the AKS subnet and the AzureFirewallSubnet"
  type        = string
}

variable "afw_subnet_name" {
  description = "Name of the subnet dedicated to Azure Firewall (must be exactly 'AzureFirewallSubnet')"
  type        = string
}

variable "afw_subnet_prefix" {
  description = "CIDR address prefix (e.g. 10.0.1.0/24) for the Azure Firewall subnet"
  type        = string
}

variable "aks_subnet_name" {
  description = "Name of the AKS cluster subnet to which the route table will be associated"
  type        = string
}

variable "aks_subnet_prefix" {
  description = "CIDR address prefix (e.g. 10.0.0.0/24) of the AKS subnet (for reference/documentation)"
  type        = string
}

variable "route_table_name" {
  description = "Name of the Route Table that forces outbound traffic from AKS through the Azure Firewall"
  type        = string
}

variable "public_ip_name" {
  description = "Name of the Public IP resource that will serve as the firewall's frontend IP"
  type        = string
}

variable "firewall_name" {
  description = "Name of the Azure Firewall instance, derived from the common prefix"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "Existing public IP address of the AKS LoadBalancer (NGINX), used in the DNAT rule"
  type        = string
}
