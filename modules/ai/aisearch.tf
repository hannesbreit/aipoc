resource "azurerm_search_service" "this" {
  name                          = "ais-${var.prefix}-${var.stage}-weu"
  location                      = "westeurope"
  resource_group_name           = azurerm_resource_group.this.name
  sku                           = "standard"
  semantic_search_sku           = "free"
  replica_count                 = 1
  partition_count               = 1
  public_network_access_enabled = var.private_endpoint ? false : true
  local_authentication_enabled  = var.local_authentication_enabled


  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "this_ais" {
  count               = var.private_endpoint ? 1 : 0
  name                = "pe-ais-${var.prefix}-${var.stage}-weu"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-ais-${var.prefix}-${var.stage}-weu"
    private_connection_resource_id = azurerm_search_service.this.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]

  }
}

resource "azurerm_key_vault_secret" "ais-primary_access_key" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "ais-primary-access-key-${var.prefix}"
  value        = azurerm_search_service.this.primary_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "ais-secondary_access_key" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "ais-secondary-access-key-${var.prefix}"
  value        = azurerm_search_service.this.secondary_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "ais-endpoint" {
  name         = "ais-endpoint-${var.prefix}"
  value        = "https://${azurerm_search_service.this.name}.search.windows.net"
  key_vault_id = var.key_vault_id
}

