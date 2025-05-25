variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "location" {
  description = "Azure region for firewall resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet to route through the firewall"
  type        = string
}

variable "aks_subnet_prefix" {
  description = "CIDR prefix of the AKS subnet"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for naming all resources"
  type        = string
}
variable "afw_subnet_name" {
  description = "Name for the Azure Firewall subnet"
  type        = string
}

variable "afw_subnet_prefix" {
  description = "CIDR prefix for the Azure Firewall subnet"
  type        = string
}

variable "firewall_name" {
  description = "Name for the Azure Firewall instance"
  type        = string
}

variable "public_ip_name" {
  description = "Name for the firewall public IP resource"
  type        = string
}

variable "route_table_name" {
  description = "Name for the route table associated with the AKS subnet"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "Existing AKS Load Balancer public IP address for DNAT"
  type        = string
}
