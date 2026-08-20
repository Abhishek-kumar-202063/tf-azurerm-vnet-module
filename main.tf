locals {
  vnet_name = "vnet-${lower(var.environment)}-${lower(var.name)}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  tags = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.tags
  )

  lifecycle {
    prevent_destroy = true
  }
}

# ============================================================
# Lock Section
# ============================================================

resource "azurerm_management_lock" "vnet_lock" {
  count = var.enable_lock ? 1 : 0

  name       = var.lock_name != null ? var.lock_name : "${local.vnet_name}-lock"
  scope      = azurerm_virtual_network.vnet.id
  lock_level = var.lock_level
  notes      = "Managed by Terraform. Do not remove without an approved change request."
}
