provider "azurerm" {
    version = 1.38
    }
    
variable "prefix" {
  default = "sm"
}

resource "azurerm_resource_group" "smvmrsg" {
    name                        = "SM-VM-STA01"
    location                    = "East US"
}

resource "azurerm_virtual_network" "smnetwork" {
    name                        = "SM-EastUS-Network"
    address_space               = ["10.0.0.0/16"]
    location                    = "azurerm_resource_group.smvmrsg.location"
    resource_group_name         = "azurerm_resource_group.smvmrsg.name"
}

resource "azurerm_subnet" "server" {
    name                        = "SM-Server-Subnet"
    resource_group_name         = "azurerm_resource_group.smvmrsg.name"
    virtual_network_name        = "azurerm_virtual_network.smnetwork.name"
    address_prefix              = "10.20.20.0/24"
}

resource "azurerm_network_interface" "smip" {
    name                        = "smwebnic03"
    location                    = "azurerm_resource_group.smvmrsg.location"
    resource_group_name         = "azurerm_resource_group.smvmrsg.name"

    ip_configuration {
        name                    = "smconfig03"
        subnet_id               = "${azurerm_subnet.server.id}"
        private_ip_address_allocation = "Dynamic"        
    }
}

resource "azurerm_virtual_machine" "smweb03" {
    name                        = "smweb03"
    location                    = "azurerm_resource_group.smvmrsg.location"
    resource_group_name         = "azurerm_resource_group.smvmrsg.name"
    network_interface_ids       = ["azurerm_network_interface.smip.id"]
    vm_size                     = "Standard_B1ms"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "OpenLogic"
        offer = "CentOS"
        sku = "7.7"
        version = "latest"
    }

    storage_os_disk {
        name = "smweb03osdisk"
        caching = "ReadWrite"
        create_option = "fromimage"
        managed_disk_type = "standard_LRS"
    }

    os_profile {
        computer_name = "smweb03"
        admin_username = "sonicmask"
        admin_password = "P2ssw0rd"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags = {
        test = "lab"
    }
}