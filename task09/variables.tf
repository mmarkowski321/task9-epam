variable "aks_subnet_name" {
  type        = string
  description = "The name of the existing AKS subnet."
}

variable "aks_loadbalancer_ip" {
  type        = string
  description = "The public IP address of the AKS load balancer used to access NGINX."
}

variable "aks_private_ip" {
  type        = string
  description = "The private IP address of the NGINX service deployed in AKS."
}
