variable "location" {
  description = "The location/region for the Azure OpenAI service."
  type        = string
  default     = "westeurope"
}

variable "stage" {
  description = "The stage of the environment."
  type        = string
  default     = "dev"
}

variable "prefix" {
  description = "value to be used as prefix for the resources"
  type        = string
}

variable "subnet_inbound_id" {
  description = "The ID of the subnet to create private endpoints for inbound traffic."
  type        = string
}

variable "subnet_outbound_id" {
  description = "The ID of the subnet to create vnet integration for outbound traffic."
  type        = string
}

variable "startup_command" {
  description = "The startup command for the web app."
  type        = string
  default     = ""
}

variable "application_stack" {
  type = map(object({
    node_version   = optional(string)
    python_version = optional(string)
  }))
  default = {
    python = {
      python_version = "3.12"
    }
  }
}
