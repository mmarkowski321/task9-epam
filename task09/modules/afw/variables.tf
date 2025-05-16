variable "location" {
  type        = string
  description = "Azure region for deploying resources."
}

variable "rg_name" {
  type        = string
  description = "Resource group name."
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network name."
}

variable "aks_subnet_id" {
  type        = string
  description = "Subnet ID of the AKS cluster."
}

variable "aks_loadbalancer_ip" {
  type        = string
  description = "Public IP of AKS Load Balancer."
}

variable "aks_private_ip" {
  type        = string
  description = "Private IP of NGINX in AKS."
}
