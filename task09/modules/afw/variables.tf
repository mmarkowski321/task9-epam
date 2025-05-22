variable "location" {
  type        = string
  description = "The Azure region where the Azure Firewall and its related resources will be deployed."
}

variable "rg_name" {
  type        = string
  description = "The name of the existing resource group where the Azure Firewall resources will be created."
}

variable "vnet_name" {
  type        = string
  description = "The name of the existing virtual network to place the Azure Firewall subnet in."
}

variable "aks_subnet_id" {
  type        = string
  description = "The ID of the AKS subnet to which the route table will be associated."
}

variable "aks_loadbalancer_ip" {
  type        = string
  description = "The public IP address of the AKS load balancer used in the NAT rule to allow external access to NGINX."
}

variable "aks_private_ip" {
  type        = string
  description = "The private IP address of the NGINX service in AKS to which the traffic will be translated in the NAT rule."
}