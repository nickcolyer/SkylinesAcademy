resource "azurerm_resource_group" "webinartemp" {
  name     = "TerraformWebinar"
  location = "eastus"

  tags {
    environment = "Ahead Terraform Webinar"
  }
}
