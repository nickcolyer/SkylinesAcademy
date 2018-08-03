# SQL SERVER
resource "azurerm_sql_server" "sqlserver" {
  name                         = "skylinessql1"
  resource_group_name          = "${azurerm_resource_group.resource_gp.name}"
  location                     = "${azurerm_resource_group.resource_gp.location}"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
  server_name         = "${azurerm_sql_server.sqlserver.name}"
  subnet_id           = "${azurerm_subnet.dbsub.id}"
}

# DB SUBNET
resource "azurerm_subnet" "dbsub" {
  name                 = "dbsubn"
  resource_group_name  = "${azurerm_resource_group.resource_gp.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.3.0/24"
  service_endpoints    = ["Microsoft.Sql"]
}