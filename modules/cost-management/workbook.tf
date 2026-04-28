resource "azurerm_application_insights_workbook" "cost_dashboard" {
  name = "00000000-0000-0000-0000-000000000001"
  resource_group_name = azurerm_resource_group.cost_mgmt.name
  location            = azurerm_resource_group.cost_mgmt.location
  display_name        = "Azure Landing Zone — Cost Dashboard"
  tags                = var.tags

  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type    = 1
        content = { json = "# Azure Landing Zone — Cost Dashboard\nMonthly spend visibility across all resources." }
        name    = "title"
      },
      {
        type = 3
        content = {
          version       = "KqlItem/1.0"
          query         = ""
          size          = 0
          title         = "Spend by Service Category"
          queryType     = 8
          visualization = "barchart"
        }
        name = "spend-by-service"
      },
      {
        type = 3
        content = {
          version       = "KqlItem/1.0"
          query         = ""
          size          = 0
          title         = "Spend by Resource Group"
          queryType     = 8
          visualization = "table"
        }
        name = "spend-by-rg"
      },
      {
        type = 3
        content = {
          version       = "KqlItem/1.0"
          query         = ""
          size          = 0
          title         = "Daily Spend Trend"
          queryType     = 8
          visualization = "areachart"
        }
        name = "daily-trend"
      }
    ]
    "$schema" = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })
}