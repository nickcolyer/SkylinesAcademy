resource "azurerm_resource_group" "resource_gp" {
  name     = "Skylines-Demo-5"
  location = "eastus"

  tags {
    Owner = "Nick Colyer"
  }
}
