provider "azurerm" {
    version = 1.38
    }
	
# create virtual network
resource "azurerm_virtual_network" "tfnet" {
	name				= "tfvnet"
	address_space		= ["10.0.0.0/16"]
	location			= "East US"
	resource_group_name = "187-f88dbf-deploying-an-azure-vm-with-terraform-nm1"
	
	tag = {
		environment = Terraform VNET"
	}
}

# Create subnet
resource "azurerm_subnet" "tfsubnet" {
	name				= "default"
	resource_group_name = "187-f88dbf-deploying-an-azure-vm-with-terraform-nm1"
	virtual_network_name = azurerm_virtual_network.tfnet.name
	address_prefix		= "10.0.1.0/24"
}

#deploy public ip
resource "azurerm_public_ip" "azurepip1" {
	name				= "pubip1"
	location			= "east us"
	resource_group_name = "187-f88dbf-deploying-an-azure-vm-with-terraform-nm1"
	allocation_method = "Dynamic"
	sku					= "basic"
}

resource "azurerm_network_interface" "azureinternalnic1" {
	name				= "internalnic"
	location			= "East us"
	resource_group_name = "187-f88dbf-deploying-an-azure-vm-with-terraform-nm1"
	
	ip_configuration {
		name						= "ipconfig1"
		subnet_id 					= "azurerm_subnet.tfsubnet.id"
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id		  = "azurerm_public_ip.pubip1.id
		}
	}

#Create Boot Diagnostic Account
resource "azurerm_storage_account" "sa" {
  name                     = "Enter Name for Diagnostic Account" 
  resource_group_name      = "187-f88dbf-deploying-an-azure-vm-with-terraform-nm1"
  location                 = "East US"
   account_tier            = "Standard"
   account_replication_type = "LRS"

   tags = {
    environment = "Boot Diagnostic Storage"
    CreatedBy = "Admin"
   }
  }

#create virtual machine
resource "azurerm_virtual_machine" "smvm1"
	name								= "smvm01"
	location							= "East US"
	resource_group_name					= "187-f88dbf-deploying-an-azure-vm-with-terraform-nm1"
	network_interface_ids 				= [azurerm_network_interface.azureinternalnic1.id]
	vm_size								= "Standard_B1s"
	delete_os_disk_on_termination = true
	delete_data_disk_on_termination = true
	
	storage_image_reference {
	publisher = "Canonical"
	offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk1"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "smvm01"
    admin_username = "vmadmin"
    admin_password = "Password12345!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
    }

}
