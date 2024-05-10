locals {
  service = "ait"
}

resource "azurerm_cognitive_account" "this_ait" {
  name                          = "${local.service}-${var.prefix}-${var.stage}-${local.country_code}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.this.name
  kind                          = "TextTranslation"
  public_network_access_enabled = var.private_endpoint ? false : true
  custom_subdomain_name         = var.private_endpoint ? var.custom_subdomain_name : null
  local_auth_enabled            = var.private_endpoint ? false : true

  identity {
    type = "SystemAssigned"
  }

  sku_name = "S1"
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "this_ait" {
  count               = var.private_endpoint ? 1 : 0
  name                = "pe-${local.service}-${var.prefix}-${var.stage}-weu"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${local.service}-${var.prefix}-${var.stage}-weu"
    private_connection_resource_id = azurerm_cognitive_account.this_ait.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]

  }
}

resource "azurerm_key_vault_secret" "this_ait_primary_access_key" {
  count        = var.private_endpoint ? 0 : 1
  name         = "${local.service}-primary-access-key-${var.prefix}"
  value        = azurerm_cognitive_account.this_ait.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "this_ait_secondary_access_key" {
  count        = var.private_endpoint ? 0 : 1
  name         = "${local.service}-secondary-access-key-${var.prefix}"
  value        = azurerm_cognitive_account.this_ait.secondary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "this_ait_endpoint" {
  name         = "${local.service}-endpoint-${var.prefix}"
  value        = azurerm_cognitive_account.this_ait.endpoint
  key_vault_id = var.key_vault_id
}


resource "azurerm_monitor_diagnostic_setting" "this_ait" {
  name                       = "${local.service}-diagnostic-settings-${var.prefix}-${var.stage}-${local.country_code}"
  target_resource_id         = azurerm_cognitive_account.this_ait.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
