variable "resource_group_name" {
  description = "Name of the resource group where cost management resources will be deployed"
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus2"
}

variable "prefix" {
  description = "Naming prefix applied to all resources (e.g. alz-dev)"
  type        = string
  default     = "alz-dev"
}

variable "subscription_id" {
  description = "Azure subscription ID to scope the budget and cost tracking against"
  type        = string
}

variable "budget_amount" {
  description = "Monthly budget ceiling in USD. Alerts fire at 80% and 100% of this value."
  type        = number
  default     = 100
}

variable "budget_start_date" {
  description = "Start date for the budget period (YYYY-MM-DD, first of a month)"
  type        = string
  default     = "2025-01-01"
}

variable "alert_email" {
  description = "Email address that receives budget alerts and weekly cost reports"
  type        = string
  default     = "alerts@example.com"
}

variable "log_analytics_sku" {
  description = "SKU for the Log Analytics workspace."
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_days" {
  description = "Number of days to retain logs in the workspace (31-730)"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Map of tags applied to every resource in this module"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "azure-landing-zone"
    module      = "cost-management"
    managed_by  = "terraform"
  }
}