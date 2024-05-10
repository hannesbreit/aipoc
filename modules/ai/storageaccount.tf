resource "azurerm_storage_account" "this" {
  name                            = replace("sa-${var.prefix}-${var.stage}-weu", "-", "")
  resource_group_name             = azurerm_resource_group.this.name
  location                        = "westeurope"
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  access_tier                     = "Hot"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = var.private_endpoint ? false : true
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

data "azurerm_storage_account_sas" "this" {
  connection_string = azurerm_storage_account.this.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = false
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2024-05-01T00:00:00Z"
  expiry = "2024-12-31T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}


resource "azurerm_key_vault_secret" "kv_sas_url_query_string" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "sas-url-query-string"
  value        = data.azurerm_storage_account_sas.this.sas
  key_vault_id = var.key_vault_id
}


resource "azurerm_key_vault_secret" "kv_primary_connection_string" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "storage-account-primary-string"
  value        = azurerm_storage_account.this.primary_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "kv_secondary_connection_string" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "storage-account-secondary-string"
  value        = azurerm_storage_account.this.secondary_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "kv_primary_blob_connection_string" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "storage-account-primary-blob-string"
  value        = azurerm_storage_account.this.primary_blob_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "kv_secondary_blob_connection_string" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "storage-account-secondary-blob-string"
  value        = azurerm_storage_account.this.secondary_blob_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "kv_primary_access_key" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "storage-account-primary-access-key"
  value        = azurerm_storage_account.this.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "kv_secondary_access_key" {
  count        = var.local_authentication_enabled ? 1 : 0
  name         = "storage-account-secondary-access-key"
  value        = azurerm_storage_account.this.secondary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_private_endpoint" "this_sa" {
  count               = var.private_endpoint ? 1 : 0
  name                = "pe-sa-${var.prefix}-${var.stage}-weu"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-sa-${var.prefix}-${var.stage}-weu"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]

  }
}
