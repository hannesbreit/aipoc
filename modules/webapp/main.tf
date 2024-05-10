#########
# Resource Group to host all web app resources
#########
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.prefix}-${var.stage}-${local.country_code}"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


#########
# App Service Plan to host both Web Apps (Dev and Test)
#########
resource "azurerm_service_plan" "this" {
  name                = "asp-${var.prefix}-${var.stage}-${local.country_code}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = "P1v2"

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}



#########
# Dev Web App within the same App Service Plan
#########
resource "azurerm_linux_web_app" "this" {
  name                          = "app-${var.prefix}-${var.stage}-${local.country_code}"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_service_plan.this.location
  service_plan_id               = azurerm_service_plan.this.id
  https_only                    = true
  public_network_access_enabled = true
  virtual_network_subnet_id     = var.subnet_outbound_id

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true
    http_logs {
      file_system {
        retention_in_days = 31
        retention_in_mb   = 100
      }
    }
    application_logs {
      file_system_level = "Verbose"
    }

  }
  site_config {
    vnet_route_all_enabled            = true
    app_command_line                  = var.startup_command
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"
    ftps_state                        = "Disabled"

    dynamic "application_stack" {
      for_each = var.application_stack
      content {
        node_version   = application_stack.value.node_version != null ? application_stack.value.node_version : null
        python_version = application_stack.value.python_version != null ? application_stack.value.python_version : null
      }
    }

    ip_restriction {
      service_tag = "AzureDevOps"
      name        = "Allow AzureDevOps"
      priority    = 300
      action      = "Allow"
    }

    scm_ip_restriction {
      service_tag = "AzureDevOps"
      name        = "Allow AzureDevOps"
      priority    = 300
      action      = "Allow"
    }
  }

  identity {
    type = "SystemAssigned"

  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "this" {
  name                = "pe-${var.prefix}-${var.stage}-${local.country_code}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_inbound_id

  private_service_connection {
    name                           = "psc-${var.prefix}-${var.stage}-${local.country_code}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.this.id
    subresource_names              = ["sites"]
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]

  }
}


#########
# Test Web App within the same App Service Plan
#########
resource "azurerm_linux_web_app" "this2" {
  name                          = "app-${var.prefix}-test-${local.country_code}"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_service_plan.this.location
  service_plan_id               = azurerm_service_plan.this.id
  https_only                    = true
  public_network_access_enabled = true
  virtual_network_subnet_id     = var.subnet_outbound_id

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true
    http_logs {
      file_system {
        retention_in_days = 31
        retention_in_mb   = 100
      }
    }
    application_logs {
      file_system_level = "Verbose"
    }

  }
  site_config {
    vnet_route_all_enabled            = true
    app_command_line                  = var.startup_command
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"
    ftps_state                        = "Disabled"

    dynamic "application_stack" {
      for_each = var.application_stack
      content {
        node_version   = application_stack.value.node_version != null ? application_stack.value.node_version : null
        python_version = application_stack.value.python_version != null ? application_stack.value.python_version : null
      }
    }

    ip_restriction {
      service_tag = "AzureDevOps"
      name        = "Allow AzureDevOps"
      priority    = 300
      action      = "Allow"
    }

    scm_ip_restriction {
      service_tag = "AzureDevOps"
      name        = "Allow AzureDevOps"
      priority    = 300
      action      = "Allow"
    }
  }

  identity {
    type = "SystemAssigned"

  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "this2" {
  name                = "pe-${var.prefix}-test-${local.country_code}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.subnet_inbound_id

  private_service_connection {
    name                           = "psc-${var.prefix}-test-${local.country_code}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.this2.id
    subresource_names              = ["sites"]
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group, tags
    ]

  }
}
