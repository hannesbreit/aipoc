resource "azurerm_cognitive_account" "this" {
  name                          = "oai-${var.prefix}-${var.stage}-${local.country_code}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.this.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = var.private_endpoint ? false : true
  custom_subdomain_name         = var.custom_subdomain_name

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_key_vault_secret" "primary_access_key" {
  count        = var.private_endpoint ? 0 : 1
  name         = "oai-primary-access-key-${var.prefix}"
  value        = azurerm_cognitive_account.this.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "secondary_access_key" {
  count        = var.private_endpoint ? 0 : 1
  name         = "oai-secondary-access-key-${var.prefix}"
  value        = azurerm_cognitive_account.this.secondary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "endpoint" {
  name         = "oai-endpoint-${var.prefix}"
  value        = azurerm_cognitive_account.this.endpoint
  key_vault_id = var.key_vault_id
}

resource "azurerm_cognitive_deployment" "this" {
  name                 = "cd-${var.model}-${var.stage}-${local.country_code}"
  cognitive_account_id = azurerm_cognitive_account.this.id
  model {
    format  = "OpenAI"
    name    = var.model
    version = var.model_version
  }

  scale {
    type     = "Standard"
    capacity = 40
  }
}

resource "azurerm_cognitive_deployment" "this2" {
  name                 = "cd-${var.model2}-${var.stage}-${local.country_code}"
  cognitive_account_id = azurerm_cognitive_account.this.id
  model {
    format  = "OpenAI"
    name    = var.model2
    version = var.model2_version

  }
  scale {
    type     = "Standard"
    capacity = 175
  }
}


resource "azurerm_private_endpoint" "this_oai" {
  count               = var.private_endpoint ? 1 : 0
  name                = "pe-oai-${var.prefix}-${var.stage}-weu"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-oai-${var.prefix}-${var.stage}-weu"
    private_connection_resource_id = azurerm_cognitive_account.this.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]

  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "oai-diagnostic-settings-${var.prefix}-${var.stage}-${local.country_code}"
  target_resource_id         = azurerm_cognitive_account.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
