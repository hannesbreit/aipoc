resource "azurerm_role_assignment" "permission8" {
  scope                = module.openaitest.azurerm_resource_group_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_group.GenAI-Reader.object_id
}

resource "azurerm_role_assignment" "permission9" {
  scope                = module.openai.azurerm_storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = module.openai.azurerm_search_service_managed_identity
}

resource "azurerm_role_assignment" "permission16" {
  scope                = module.openai.azurerm_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.openai.azure_ai_translator_managed_identity
}

resource "azurerm_role_assignment" "permission17" {
  scope                = module.openaitest.azurerm_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.openaitest.azure_ai_translator_managed_identity
}







resource "azurerm_role_assignment" "permission1" {
  scope                = module.openai.azurerm_cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = module.webappBackend.webapp_system_identity
}

resource "azurerm_role_assignment" "permission2" {
  scope                = module.openai.azurerm_search_service_id
  role_definition_name = "Search Service Contributor"
  principal_id         = module.webappBackend.webapp_system_identity
}

resource "azurerm_role_assignment" "permission3" {
  scope                = module.openai.azurerm_search_service_id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = module.webappBackend.webapp_system_identity
}

resource "azurerm_role_assignment" "permission4" {
  scope                = module.services.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = module.webappBackend.webapp_system_identity
}

resource "azurerm_role_assignment" "permission5" {
  scope                = module.openai.azurerm_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.webappBackend.webapp_system_identity
}

resource "azurerm_role_assignment" "permission6" {
  scope                = module.webappBackend.azurerm_linux_web_app_id
  role_definition_name = "Contributor"
  principal_id         = module.webappFrontend.webapp_system_identity
}







resource "azurerm_role_assignment" "permission10" {
  scope                = module.openai.azurerm_cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = module.webappBackend.webapp_system_identity_2
}

resource "azurerm_role_assignment" "permission11" {
  scope                = module.openai.azurerm_search_service_id
  role_definition_name = "Search Service Contributor"
  principal_id         = module.webappBackend.webapp_system_identity_2
}

resource "azurerm_role_assignment" "permission12" {
  scope                = module.openai.azurerm_search_service_id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = module.webappBackend.webapp_system_identity_2
}

resource "azurerm_role_assignment" "permission13" {
  scope                = module.services.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = module.webappBackend.webapp_system_identity_2
}

resource "azurerm_role_assignment" "permission14" {
  scope                = module.openai.azurerm_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.webappBackend.webapp_system_identity_2
}

resource "azurerm_role_assignment" "permission15" {
  scope                = module.webappBackend.azurerm_linux_web_app_id_2
  role_definition_name = "Contributor"
  principal_id         = module.webappFrontend.webapp_system_identity_2
}
