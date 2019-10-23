resource "azurerm_resource_group" "demoResourceGroup_Deep" {
  location = "koreacentral"
  name = "demoResourceGroup_Deep"
  tags = {
    environment = "Test"
  }
}

resource "azurerm_virtual_network" "demoVirtualNetwork_Deep" {
  location = "${azurerm_resource_group.demoResourceGroup_Deep.location}"
  name = "demoVirtualNetwork_Deep"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  address_space = ["172.20.0.0/16"]
  tags = {
    environment = "${azurerm_resource_group.demoResourceGroup_Deep.tags.environment}"
  }
}

resource "azurerm_subnet" "demoSubnetPublic_Deep" {
  name = "demoSubnetPublic_Deep"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  virtual_network_name = "${azurerm_virtual_network.demoVirtualNetwork_Deep.name}"
  address_prefix = "172.20.10.0/24"
  service_endpoints = ["Microsoft.Web"]
}

resource "azurerm_subnet" "demoSubnetPrivate_Deep" {
  name = "demoSubnetPrivate_Deep"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  virtual_network_name = "${azurerm_virtual_network.demoVirtualNetwork_Deep.name}"
  address_prefix = "172.20.20.0/24"
  service_endpoints = ["Microsoft.Web"]
}

resource "azurerm_public_ip" "demoPublicIP_Deep" {
  name = "demoPublicIPDeep"
  location = "${azurerm_resource_group.demoResourceGroup_Deep.location}"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  allocation_method = "Dynamic"
  tags = {
    environment = "${azurerm_resource_group.demoResourceGroup_Deep.tags.environment}"
  }
}

resource "azurerm_network_interface" "public_demoNetworkInterface_Deep" {
  name = "public_demoNetworkInterface_Deep"
  location = "${azurerm_resource_group.demoResourceGroup_Deep.location}"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  ip_configuration {
    name = "public_demoNetworkInterface_Configuration"
    subnet_id = "${azurerm_subnet.demoSubnetPublic_Deep.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.demoPublicIP_Deep.id}"
  }
  tags = {
    environment = "${azurerm_resource_group.demoResourceGroup_Deep.tags.environment}"
  }
}

resource "azurerm_network_interface" "private_demoNetworkInterface_Deep" {
  name = "private_demoNetworkInterface_Deep"
  location = "${azurerm_resource_group.demoResourceGroup_Deep.location}"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  ip_configuration {
    name = "private_demoNetworkInterface_Configuration"
    subnet_id = "${azurerm_subnet.demoSubnetPrivate_Deep.id}"
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    environment = "${azurerm_resource_group.demoResourceGroup_Deep.tags.environment}"
  }
}

resource "azurerm_virtual_machine" "public_demoVirtualMachine_Deep" {
  name = "public_demoVirtualMachine_Deep"
  location = "${azurerm_resource_group.demoResourceGroup_Deep.location}"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  network_interface_ids = ["${azurerm_network_interface.public_demoNetworkInterface_Deep.id}"]
  vm_size = "Standard_B1ms"

  storage_os_disk {
    name = "public_vm_os_disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }

  os_profile {
    computer_name = "publicVmDeep"
    admin_username = "adminuser"
    custom_data = "${file("./cloud-init.sh")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/adminuser/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAj/forJI+fR7P/E2BNVcUY2yMfNdz9wAjn6GaHDrlaolqaCy+It1Hej2iYVKa5dOFpofRX8vccvDnsQh4IL+SrboRMdMNevtpSSSNUaIlYzTC0342Pm0jZV5Gjjee0dY+QSbOw1o4I4ARGukuZBDWny9ixWzIDhGHsQ6mqcChjfhnbBVatRg02t8ky2dTMPZpUAMyyNZPhyloq6BpPq3ybzqPOmrF0bPIU5xRBXoDb6bZpnZIZO9koRYYRoRwmVGOejqa0uiJNaiwBbbkL/yof6qD+cz6ir4VGTKS0kTDSLON2Ao8CZcUG8U2uW9y81crJHCaHPVoQiWsbaGdxmVX deepjyotiborah@LE0005.local"
    }
  }
  tags = {
    environment = "${azurerm_resource_group.demoResourceGroup_Deep.tags.environment}"
  }
}

resource "azurerm_virtual_machine" "private_demoVirtualMachine_Deep" {
  name = "private_demoVirtualMachine_Deep"
  location = "${azurerm_resource_group.demoResourceGroup_Deep.location}"
  resource_group_name = "${azurerm_resource_group.demoResourceGroup_Deep.name}"
  network_interface_ids = ["${azurerm_network_interface.private_demoNetworkInterface_Deep.id}"]
  vm_size = "Standard_B1ms"

  storage_os_disk {
    name = "private_vm_os_disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }

  os_profile {
    computer_name = "privateVmDeep"
    admin_username = "adminuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/adminuser/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAj/forJI+fR7P/E2BNVcUY2yMfNdz9wAjn6GaHDrlaolqaCy+It1Hej2iYVKa5dOFpofRX8vccvDnsQh4IL+SrboRMdMNevtpSSSNUaIlYzTC0342Pm0jZV5Gjjee0dY+QSbOw1o4I4ARGukuZBDWny9ixWzIDhGHsQ6mqcChjfhnbBVatRg02t8ky2dTMPZpUAMyyNZPhyloq6BpPq3ybzqPOmrF0bPIU5xRBXoDb6bZpnZIZO9koRYYRoRwmVGOejqa0uiJNaiwBbbkL/yof6qD+cz6ir4VGTKS0kTDSLON2Ao8CZcUG8U2uW9y81crJHCaHPVoQiWsbaGdxmVX deepjyotiborah@LE0005.local"
    }
  }
  tags = {
    environment = "${azurerm_resource_group.demoResourceGroup_Deep.tags.environment}"
  }
}









