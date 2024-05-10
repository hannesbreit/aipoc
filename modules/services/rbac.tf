locals {
  users = [
    {
      name  = "hannes"
      email = "admin.hannes.breitfeld@fresenius.onmicrosoft.com"
    },
    {
      name  = "thorsten"
      email = "admin.thorsten.fleckenstein@fresenius.onmicrosoft.com"
    },
    {
      name  = "manikandan"
      email = "admin.manikandan.sundarraj@fresenius.onmicrosoft.com"
    }
  ]
}

data "azuread_user" "users" {
  for_each            = { for user in local.users : user.name => user.email }
  user_principal_name = each.value
}

resource "azurerm_role_assignment" "users" {
  for_each             = { for user in local.users : user.name => user.email }
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_user.users[each.key].object_id
}



resource "azurerm_role_assignment" "_4" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}



data "azuread_group" "group" {
  display_name = "Azure-SCP-Kabi-GenAI-Reader"
}

resource "azurerm_role_assignment" "_5" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_group.group.object_id
}
