variable "location" {
  description = "The location/region for the Azure OpenAI service."
  type        = string
}

variable "stage" {
  description = "value for the stage"
  type        = string
}

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string

}

variable "subnet_id" {
  description = "The subnet ID for the private endpoint"
  type        = string

}

variable "key_vault_id" {
  description = "The key vault ID for the private endpoint"
  type        = string

}