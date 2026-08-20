output "name" {
  description = "Generated Virtual Network name. Format: vnet-<location>-<env>-<name>."
  value       = azurerm_virtual_network.vnet.name
}

output "id" {
  description = "Azure Resource ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "location" {
  description = "Azure region of the Virtual Network."
  value       = azurerm_virtual_network.vnet.location
}

output "address_space" {
  description = "Address space CIDR blocks of the Virtual Network."
  value       = azurerm_virtual_network.vnet.address_space
}

output "resource" {
  description = "Full azurerm_virtual_network resource object."
  value       = azurerm_virtual_network.vnet
}

output "lock_id" {
  description = "Resource ID of the Management Lock. null if enable_lock = false."
  value       = var.enable_lock ? azurerm_management_lock.vnet_lock[0].id : null
}
