variable "prefix" {
  description = "Naming prefix for all resources"
  type        = string
  default     = "alz-dev"
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "azure-landing-zone"
  }
}
