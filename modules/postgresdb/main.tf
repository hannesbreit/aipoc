resource "azurerm_resource_group" "this" {
  name     = "rg-${var.prefix}-${var.stage}-${local.country_code}"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags,
    ]

  }
}

resource "random_password" "this" {
  length  = 16
  upper   = true
  lower   = true
  numeric = true
  special = false
}

resource "azurerm_key_vault_secret" "this" {
  name         = "psqladmin"
  value        = random_password.this.result
  key_vault_id = var.key_vault_id
}


resource "azurerm_postgresql_server" "this" {
  name                = "pgsrv-${var.prefix}-${var.stage}-${local.country_code}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  sku_name = "GP_Gen5_2"

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  administrator_login          = "psqladmin"
  administrator_login_password = random_password.this.result
  version                      = "11"
  ssl_enforcement_enabled      = true

  lifecycle {
    ignore_changes = [
      tags, threat_detection_policy
    ]

  }
}

resource "azurerm_postgresql_database" "this" {
  name                = "psql-${var.prefix}-${var.stage}-${local.country_code}"
  resource_group_name = azurerm_resource_group.this.name
  server_name         = azurerm_postgresql_server.this.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_private_endpoint" "this" {
  name                = "pe-psql-${var.prefix}-${var.stage}-${local.country_code}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-psql-${var.prefix}-${var.stage}-${local.country_code}"
    private_connection_resource_id = azurerm_postgresql_server.this.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]
  }
}
