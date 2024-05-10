resource "azurerm_resource_group" "this" {
  name     = "rg-${var.prefix}-${var.stage}-${local.country_code}"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "azurerm_key_vault" "this" {
  name                = replace("kv-${var.prefix}-${var.stage}-${local.country_code}", "-", "")
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  sku_name = "standard"

  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = true
  enable_rbac_authorization       = true
  public_network_access_enabled   = true


  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}



resource "azurerm_private_endpoint" "this" {
  name                = "pe-kv-${var.prefix}-${var.stage}-${local.country_code}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-kv-${var.prefix}-${var.stage}-${local.country_code}"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]

  }

}
