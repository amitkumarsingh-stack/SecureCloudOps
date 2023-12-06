variable "resource_group_name" {
  description = ""
  default     = ""
}

variable "location" {
  description = ""
  default     = ""
}

variable "default_tags" {
  type    = map(string)
  default = {
    Environment = "Production"
    Department  = "IT"
    Owner       = "John Doe"
    // Add more key-value pairs as needed
  }
}

variable "address_space" {
  description = ""
  default     = ""
}

variable "subnet" {
  description = ""
  default     = ""
}

variable "application" {
  description = ""
  default     = ""
}

variable "environment" {
  description = ""
  default     = ""
}

variable "capacity" {
  description = ""
  default     = ""
}