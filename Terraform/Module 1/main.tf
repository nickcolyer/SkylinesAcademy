#Resource Group Creation
resource "azurerm_resource_group" "resource_gp" {
  name     = "Skylines-Terraform"
  location = "eastus"

  tags {
    Owner = "Nick Colyer"
  }
}

#NETWORK
resource "azurerm_virtual_network" "network" {
  name                = "${var.app_name}"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
}

# MAIN SUBNET
resource "azurerm_subnet" "mainsubnet" {
  name                 = "mainsubnet"
  resource_group_name  = "${azurerm_resource_group.resource_gp.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.3.0/24"
}

resource "azurerm_network_interface" "netint" {
  name                = "networkinterface-${count.index + 1}"
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
  count               = "1"

  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = "${azurerm_subnet.mainsubnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

## Virtual Machine
resource "azurerm_virtual_machine" "app_vm" {
  name                          = "${var.app_name}-vmexample-${count.index + 1}"
  location                      = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name           = "${azurerm_resource_group.resource_gp.name}"
  network_interface_ids         = ["${element(azurerm_network_interface.netint.*.id, count.index)}"]
  vm_size                       = "Standard_DS1_v2"
  count                         = "1"
  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.app_name}-osdisk1-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.app_name}-${count.index + 1}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "Production"
  }
}
