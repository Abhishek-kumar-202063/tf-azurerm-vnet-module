variable "name" {
  description = "Name identifier provided by the developer. Used to generate: vnet-<env>-<name>."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+$", var.name)) && length(var.name) > 0
    error_message = "name must contain only letters, numbers, or hyphens and must not be empty."
  }
}

variable "location" {
  description = "Azure region where the Virtual Network will be created. Example: 'East US 2'."
  type        = string
}

variable "environment" {
  description = "Deployment environment. Example: 'dev', 'uat', 'staging', 'prod'."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]+$", var.environment)) && length(var.environment) > 0
    error_message = "environment must contain only letters and numbers and must not be empty."
  }
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the Virtual Network will be created."
  type        = string
}

variable "address_space" {
  description = "List of CIDR blocks for the Virtual Network address space. Example: ['10.0.0.0/16']."
  type        = list(string)
}

variable "dns_servers" {
  description = "List of custom DNS server IP addresses. Leave empty to use Azure default DNS."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to merge. Governance tags (environment, managed_by) are always applied."
  type        = map(string)
  default     = {}
}

# ============================================================
# Lock Section
# ============================================================

variable "enable_lock" {
  description = "Apply an Azure Management Lock. Recommended for production. Default: false."
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "Lock level: 'CanNotDelete' or 'ReadOnly'. Default: 'CanNotDelete'."
  type        = string
  default     = "CanNotDelete"

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "lock_level must be either 'CanNotDelete' or 'ReadOnly'."
  }
}

variable "lock_name" {
  description = "Custom lock name. Defaults to '<vnet-name>-lock' if not set."
  type        = string
  default     = null
}
