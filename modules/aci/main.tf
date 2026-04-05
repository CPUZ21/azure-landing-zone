resource "azurerm_container_group" "main" {
  name                = "${var.prefix}-aci"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  restart_policy      = "Never"

  container {
    name   = "rhel-container"
    image  = "redhat/ubi9:latest"
    cpu    = "1"
    memory = "1.5"

    commands = ["/bin/bash", "-c", "echo 'Azure Landing Zone - RHEL UBI9 Container Running' && sleep 3600"]

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = var.tags
}
