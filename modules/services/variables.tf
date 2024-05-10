variable "location" {
  description = "The location/region for the Key Vault."
  type        = string
}

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
}

variable "stage" {
  description = "value for the stage"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the private endpoint"
  type        = string

}
