output "resource_group_name" {
  description = "Name of the cost management resource group"
  value       = azurerm_resource_group.cost_mgmt.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.cost_mgmt.id
}

output "log_analytics_workspace_key" {
  description = "Primary shared key for the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.cost_mgmt.primary_shared_key
  sensitive   = true
}

output "function_app_hostname" {
  description = "Default hostname of the cost report Function App"
  value       = azurerm_linux_function_app.cost_report.default_hostname
}

output "function_app_identity_principal_id" {
  description = "Managed identity principal ID of the Function App"
  value       = azurerm_linux_function_app.cost_report.identity[0].principal_id
}

output "logic_app_id" {
  description = "Resource ID of the Logic App workflow"
  value       = azurerm_logic_app_workflow.cost_report.id
}

output "workbook_id" {
  description = "Resource ID of the cost dashboard Workbook"
  value       = azurerm_application_insights_workbook.cost_dashboard.id
}

output "budget_id" {
  description = "Resource ID of the subscription budget"
  value       = azurerm_consumption_budget_subscription.main.id
}

output "action_group_id" {
  description = "Resource ID of the cost alert Action Group"
  value       = azurerm_monitor_action_group.cost_alerts.id
}