variable "name_prefix" {
  description = "naming prefix"
  type        = string
}
variable "location" {
  description = "Region"
  type        = string

}
variable "aks_loadbalancer_ip" {
  description = "Existing AKS Load Balancer Public IP"
  type        = string
}

variable "aks_subnet_name" {
  description = "AKS subnet"
  type        = string

}

variable "aks_subnet_prefix" {
  description = "CIDR prefix"
  type        = string

}