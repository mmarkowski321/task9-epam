variable "aks_loadbalancer_ip" {
  description = "Public IP of the existing AKS LoadBalancer (NGINX)"
  type        = string
}

variable "aks_private_ip" {
  description = "Private IP of the NGINX service inside AKS"
  type        = string
}
