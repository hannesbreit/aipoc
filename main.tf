module "webappFrontend" {
  source             = "./modules/webapp"
  prefix             = "${var.prefix}-frontend"
  stage              = "dev"
  location           = "westeurope"
  subnet_inbound_id  = data.azurerm_subnet.frontend_inbound_subnet.id
  subnet_outbound_id = data.azurerm_subnet.frontend_outbound_subnet.id
  application_stack = {
    node = {
      node_version = "18-lts"
    }
  }
}

module "webappBackend" {
  source             = "./modules/webapp"
  prefix             = "${var.prefix}-backend"
  stage              = "dev"
  location           = "westeurope"
  subnet_inbound_id  = data.azurerm_subnet.backend_inbound_subnet.id
  subnet_outbound_id = data.azurerm_subnet.backend_outbound_subnet.id
  startup_command    = "python server.py"
  application_stack = {
    python = {
      python_version = "3.12"
    }
  }
}

module "openai" {
  source                       = "./modules/ai"
  prefix                       = "${var.prefix}-ai"
  model                        = "gpt-4-32k"
  model_version                = "0613"
  model2                       = "text-embedding-ada-002"
  model2_version               = "2"
  stage                        = "dev"
  location                     = "swedencentral"
  subnet_id                    = data.azurerm_subnet.ai_subnet.id
  key_vault_id                 = module.services.key_vault_id
  private_endpoint             = true
  custom_subdomain_name        = "oai-${var.prefix}"
  local_authentication_enabled = false
}

module "openaitest" {
  source                       = "./modules/ai"
  prefix                       = "${var.prefix}-ai-test"
  model                        = "gpt-4-32k"
  model_version                = "0613"
  model2                       = "text-embedding-ada-002"
  model2_version               = "2"
  stage                        = "dev"
  location                     = "swedencentral"
  subnet_id                    = data.azurerm_subnet.ai_subnet.id
  key_vault_id                 = module.services.key_vault_id
  private_endpoint             = false
  custom_subdomain_name        = "oai-${var.prefix}-test"
  local_authentication_enabled = true
}

module "database" {
  source       = "./modules/postgresdb"
  prefix       = "${var.prefix}-db"
  stage        = "dev"
  location     = "westeurope"
  subnet_id    = data.azurerm_subnet.database_subnet.id
  key_vault_id = module.services.key_vault_id
}

module "services" {
  source    = "./modules/services"
  prefix    = "${var.prefix}-services"
  stage     = "dev"
  location  = "westeurope"
  subnet_id = data.azurerm_subnet.services_subnet.id
}

module "jumphost" {
  source       = "./modules/jumphost"
  prefix       = "${var.prefix}-jumphost"
  stage        = "dev"
  location     = "westeurope"
  sizing       = "Standard_D2ds_v5"
  subnet_id    = data.azurerm_subnet.jumphost_subnet.id
  key_vault_id = module.services.key_vault_id
}
