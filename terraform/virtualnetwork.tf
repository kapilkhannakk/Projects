provider "azurerm" {
    version = 1.38
    }
# create virtual network
resource "azurerm_virtual_network" "smnet" {
	name						= "smlabnet"
	address_space				= ["10.0.0.0/16"]
	location					= "eastus"
	resource_group_name			= "155-a7e2a6-deploy-azure-vlans-and-subnets-with-terraform-g1s"
	
	tags = {
			environment = "Terraform Networking"
	}
}

#create subnet
resource "azurerm_subnet" "smlabsubnet" {
	name						= "smlabnet"
	resource_group_name			= "155-a7e2a6-deploy-azure-vlans-and-subnets-with-terraform-g1s"
	virtual_network_name 		= azurerm_virtual_network.smnet.name
	address_prefix				= "10.0.1.0/24"
}
resource "azurerm_subnet" "smlabsubnet2" {
	name						= "smlabnet2"
	resource_group_name			= "155-a7e2a6-deploy-azure-vlans-and-subnets-with-terraform-g1s"
	virtual_network_name		= azurerm_virtual_network.smnet.name
	address_prefix				= "10.0.2.0/24"
}