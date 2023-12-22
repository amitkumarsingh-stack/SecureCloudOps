variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Azure region where the Resource Group should be created"
}

variable "create_resource_group" {
  description = "Flag to determine whether to create the Resource Group"
  type        = bool
  default     = true
}
