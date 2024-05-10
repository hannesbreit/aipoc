variable "location" {
  type        = string
  description = "The Azure region in which the resources will be deployed."
}

variable "prefix" {
  type        = string
  description = "A prefix to add to the names of the resources."

}

variable "stage" {
  type        = string
  description = "The stage of the environment."

}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet in which the resources will be deployed."

}

variable "key_vault_id" {
  type        = string
  description = "The ID of the key vault to use for secrets."

}

variable "sizing" {
  type        = string
  description = "The size of the virtual machine."

}