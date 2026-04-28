resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

module "networking" {
  source = "./modules/networking"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

module "aci" {
  source = "./modules/aci"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

module "cost_management" {
  source = "./modules/cost-management"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  subscription_id     = var.subscription_id
  alert_email         = "alerts@example.com"
  budget_amount       = 100
  budget_start_date   = "2025-01-01"
  tags                = var.tags
}