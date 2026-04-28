resource "azurerm_storage_account" "function" {
  name                     = "${replace(var.prefix, "-", "")}fnsa"
  resource_group_name      = azurerm_resource_group.cost_mgmt.name
  location                 = azurerm_resource_group.cost_mgmt.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_service_plan" "function" {
  name                = "${var.prefix}-cost-fn-asp"
  resource_group_name = azurerm_resource_group.cost_mgmt.name
  location            = azurerm_resource_group.cost_mgmt.location
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = var.tags
}

resource "azurerm_linux_function_app" "cost_report" {
  name                       = "${var.prefix}-cost-report-fn"
  resource_group_name        = azurerm_resource_group.cost_mgmt.name
  location                   = azurerm_resource_group.cost_mgmt.location
  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key
  service_plan_id            = azurerm_service_plan.function.id
  tags                       = var.tags

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "python"
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    AzureWebJobsStorage            = azurerm_storage_account.function.primary_connection_string
    ENABLE_ORYX_BUILD              = "true"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    SUBSCRIPTION_ID                = var.subscription_id
    LOG_ANALYTICS_WORKSPACE_ID     = azurerm_log_analytics_workspace.cost_mgmt.workspace_id
    WEBSITE_RUN_FROM_PACKAGE       = "1"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }
}

resource "azurerm_role_assignment" "function_cost_reader" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Cost Management Reader"
  principal_id         = azurerm_linux_function_app.cost_report.identity[0].principal_id
}