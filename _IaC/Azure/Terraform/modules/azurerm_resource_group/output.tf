output "id" {
  value       = "${azurerm_resource_group.main.id}"
  description = "The resource group ID"
}

output "name" {
  value       = "${var.resource_group_name}"
  description = "The name of the resource group."
}

output "location" {
  value       = "${var.location}"
  description = "The location where the resource group has be created."
}