resource "azurerm_logic_app_workflow" "cost_report" {
  name                = "${var.prefix}-cost-report-la"
  location            = azurerm_resource_group.cost_mgmt.location
  resource_group_name = azurerm_resource_group.cost_mgmt.name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_logic_app_trigger_http_request" "cost_report" {
  name         = "manual-http-trigger"
  logic_app_id = azurerm_logic_app_workflow.cost_report.id

  schema = jsonencode({
    type = "object"
    properties = {
      alertContext = { type = "object" }
    }
  })
}

resource "azurerm_logic_app_trigger_recurrence" "weekly" {
  name         = "weekly-monday-trigger"
  logic_app_id = azurerm_logic_app_workflow.cost_report.id
  frequency    = "Week"
  interval     = 1

  schedule {
    at_these_hours   = [8]
    at_these_minutes = [0]
    on_these_days    = ["Monday"]
  }
}

resource "azurerm_logic_app_action_http" "call_function" {
  name         = "call-cost-report-function"
  logic_app_id = azurerm_logic_app_workflow.cost_report.id
  method       = "GET"
  uri          = "https://${azurerm_linux_function_app.cost_report.default_hostname}/api/GenerateCostReport"

  headers = {
    "x-functions-key" = "@{listKeys(resourceId('Microsoft.Web/sites/functions', '${azurerm_linux_function_app.cost_report.name}', 'GenerateCostReport'), '2022-03-01').default}"
    "Content-Type"    = "application/json"
  }

  depends_on = [azurerm_logic_app_trigger_recurrence.weekly]
}

resource "azurerm_logic_app_action_custom" "send_email" {
  name         = "send-cost-report-email"
  logic_app_id = azurerm_logic_app_workflow.cost_report.id

  body = jsonencode({
    runAfter = {
      "call-cost-report-function" = ["Succeeded"]
    }
    type = "ApiConnection"
    inputs = {
      host = {
        connection = {
          name = "@parameters('$connections')['office365']['connectionId']"
        }
      }
      method = "post"
      path   = "/v2/Mail"
      body = {
        To         = var.alert_email
        Subject    = "Weekly Azure Cost Report — @{formatDateTime(utcNow(), 'MMMM dd, yyyy')}"
        Body       = "@{body('call-cost-report-function')}"
        Importance = "Normal"
      }
    }
  })

  depends_on = [azurerm_logic_app_action_http.call_function]
}