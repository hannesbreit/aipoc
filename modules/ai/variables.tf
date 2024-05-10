variable "location" {
  description = "The location/region for the Azure OpenAI service."
  type        = string
}

variable "prefix" {
  description = "value to be prefixed to all resources"
  type        = string
}

variable "stage" {
  description = "The stage of the environment"
  type        = string

}

variable "model" {
  description = "The model to be deployed"
  type        = string

}

variable "model_version" {
  description = "The version of the model to be deployed"
  type        = string

}

variable "subnet_id" {
  description = "The subnet to deploy the OpenAI service"
  type        = string

}

variable "model2" {
  description = "The second model to be deployed"
  type        = string

}

variable "model2_version" {
  description = "The version of the second model to be deployed"
  type        = string

}

variable "key_vault_id" {
  description = "The key vault to store the secrets"
  type        = string

}

variable "private_endpoint" {
  description = "The private endpoint to be created"
  type        = bool

}

variable "custom_subdomain_name" {
  description = "The custom subdomain name for the OpenAI service"
  type        = string
  default     = null
}

variable "local_authentication_enabled" {
  description = "The local authentication enabled for the OpenAI service"
  type        = bool

}
