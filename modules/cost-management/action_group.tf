resource "azurerm_monitor_action_group" "cost_alerts" {
  name                = "${var.prefix}-cost-alert-ag"
  resource_group_name = azurerm_resource_group.cost_mgmt.name
  short_name          = "costalerts"
  tags                = var.tags

  email_receiver {
    name                    = "cost-alert-email"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  logic_app_receiver {
    name                    = "cost-report-logic-app"
    resource_id             = azurerm_logic_app_workflow.cost_report.id
    callback_url            = azurerm_logic_app_trigger_http_request.cost_report.callback_url
    use_common_alert_schema = true
  }
}