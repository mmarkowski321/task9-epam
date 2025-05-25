variable "rg_name" {
  description = "Existing Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region for Firewall"
  type        = string
}

variable "vnet_name" {
  description = "Existing VNet name"
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the AKS subnet"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "Public IP of the AKS LoadBalancer"
  type        = string
}

variable "aks_private_ip" {
  description = "Private IP of the NGINX service inside AKS"
  type        = string
}
