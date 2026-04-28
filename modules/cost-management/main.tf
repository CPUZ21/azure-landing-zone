terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_resource_group" "cost_mgmt" {
  name     = "${var.prefix}-cost-mgmt-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "cost_mgmt" {
  name                = "${var.prefix}-cost-mgmt-law"
  location            = azurerm_resource_group.cost_mgmt.location
  resource_group_name = azurerm_resource_group.cost_mgmt.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}