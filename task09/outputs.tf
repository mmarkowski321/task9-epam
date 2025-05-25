output "azure_firewall_private_ip" {
  description = "Private IP of the Azure Firewall"
  value       = module.afw.private_ip_address
}

output "azure_firewall_public_ip" {
  description = "Public IP of the Azure Firewall"
  value       = module.afw.public_ip_address
}

