output "rg_name" {
  value = azurerm_resource_group.this.name
}




output "app_service_plan_id" {
  value = azurerm_service_plan.this.id

}




output "webapp_system_identity" {
  value = azurerm_linux_web_app.this.identity[0].principal_id

}

output "azurerm_linux_web_app_id" {
  value = azurerm_linux_web_app.this.id
}







output "webapp_system_identity_2" {
  value = azurerm_linux_web_app.this2.identity[0].principal_id

}

output "azurerm_linux_web_app_id_2" {
  value = azurerm_linux_web_app.this2.id
}

