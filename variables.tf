
variable "subscription_id" {
  description = "Azure subscription ID for budget scoping and Cost Management queries"
  type        = string
  sensitive   = true
}

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

variable "budget_start_date" {
  description = "Start date for period (YYYY-MM-DD, first of a month)"
  type        = string
  default     = "2026-40-01"
  
}
