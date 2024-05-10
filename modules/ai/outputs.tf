output "primary_access_key" {
  value     = azurerm_cognitive_account.this.primary_access_key
  sensitive = true
}

output "secondary_access_key" {
  value     = azurerm_cognitive_account.this.secondary_access_key
  sensitive = true
}

output "azurerm_cognitive_account_id" {
  value = azurerm_cognitive_account.this.id
}

output "azurerm_search_service_id" {
  value = azurerm_search_service.this.id
}

output "azurerm_storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "azurerm_resource_group_id" {
  value = azurerm_resource_group.this.id
}

output "azurerm_search_service_managed_identity" {
  value = azurerm_search_service.this.identity[0].principal_id

}

output "azure_ai_translator_managed_identity" {
  value = azurerm_cognitive_account.this_ait.identity[0].principal_id
}
