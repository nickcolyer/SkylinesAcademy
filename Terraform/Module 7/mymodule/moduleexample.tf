resource "azurerm_resource_group" "resource_gp" {
  name     = "Skylines-Demo-7"
  location = "eastus"

  tags {
    Owner = "Nick Colyer"
  }
}
