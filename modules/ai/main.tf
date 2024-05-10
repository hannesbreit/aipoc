resource "azurerm_resource_group" "this" {
  name     = "rg-${var.prefix}-${var.stage}-${local.country_code}"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-${var.prefix}-${var.stage}-${local.country_code}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
