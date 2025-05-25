variable "name_prefix" {
  description = "Common prefix for naming resources"
  type        = string
}
variable "location" {
  description = "Azure region"
  type        = string

}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string

}

variable "aks_subnet_prefix" {
  description = "CIDR prefix of the AKS subnet"
  type        = string

}

variable "aks_loadbalancer_ip" {
  description = "Existing AKS Load Balancer Public IP"
  type        = string
}
