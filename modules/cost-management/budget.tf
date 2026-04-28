resource "azurerm_consumption_budget_subscription" "main" {
  name            = "${var.prefix}-monthly-budget"
  subscription_id = "/subscriptions/${var.subscription_id}"

  amount     = var.budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = "${var.budget_start_date}T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
    contact_groups = [azurerm_monitor_action_group.cost_alerts.id]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
    contact_groups = [azurerm_monitor_action_group.cost_alerts.id]
  }
}