variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  description = "value to be used as prefix for the resources"
  type        = string
  default     = "medtech"
}

variable "stage" {
  description = "The stage of the environment."
  type        = string
  default     = "dev"
}
