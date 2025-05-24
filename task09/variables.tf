variable "aks_subnet_name" {
  type        = string
  description = "The name of the existing AKS subnet."
}
variable "aks_loadbalancer_ip" {
  type        = string
  description = "Public IP of the AKS Load Balancer (NGINX)."
}
variable "aks_private_ip" {
  type        = string
  description = "Private IP of the NGINX service inside AKS."
}
