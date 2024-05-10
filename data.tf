data "azurerm_virtual_network" "spoke" {
  name                = "genai-qa-westeu-001-vnet"
  resource_group_name = "coreservices-qa-westeu-genai-rg"
}

data "azurerm_subnet" "frontend_inbound_subnet" {
  name                 = "frontend-inbound-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name
}

data "azurerm_subnet" "frontend_outbound_subnet" {
  name                 = "frontend-outbound-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name

}

data "azurerm_subnet" "backend_inbound_subnet" {
  name                 = "backend-inbound-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name

}

data "azurerm_subnet" "backend_outbound_subnet" {
  name                 = "backend-outbound-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name

}

data "azurerm_subnet" "ai_subnet" {
  name                 = "ai-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name

}

data "azurerm_subnet" "services_subnet" {
  name                 = "services-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name

}

data "azurerm_subnet" "database_subnet" {
  name                 = "database-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name

}

data "azurerm_subnet" "jumphost_subnet" {
  name                 = "jumphost-subnet"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name
}

data "azuread_group" "GenAI-Reader" {
  display_name = "Azure-SCP-Kabi-GenAI-Reader"
}