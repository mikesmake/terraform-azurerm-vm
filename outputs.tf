output "virtual_machine_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "The ID of the managed virtual machine"
}

output "vm_admin_username" {
  value       = azurerm_key_vault_secret.admin_user.value
  sensitive   = true
  description = "The local Administrator account username"
}

output "vm_admin_password" {
  value       = azurerm_key_vault_secret.admin_user_password.value
  sensitive   = true
  description = "The local administrator account password"
}

output "virtual_machine_nic_id" {
  value       = azurerm_network_interface.nic.id
  description = "The ID of the network interface of the virtual machine"
}

output "virtual_machine_hostname" {
  value       = azurerm_windows_virtual_machine.vm.computer_name
  description = "The hostname of the virtual machine"
}

output "virtual_machine_object_name" {
  value       = azurerm_windows_virtual_machine.vm.name
  description = "The Azure object name of the virtual machine"
}