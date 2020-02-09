provider "azurerm" {
    version = 1.38
    }
resource "azurerm_storage_account" "lab" {
  name                     = "sonicmasksta"
  resource_group_name      = "183-718f12-deploy-an-azure-file-share-with-terraform-rwg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "lab" {
	name				 = "blockcontainer4lab"
	storage_account_name = azurerm_storage_account.lab.name
	container_access_type = "private"
}

resource "azurerm_storage_blob" "lab" {
	name					= "terraformblob"
	storage_account_name	= azurerm_storage_account.lab.name
	storage_container_name	= azurerm_storage_container.lab.name
	type					= "Block"
}

resource "azurerm_storage_share" "lab" {
	name					= "terraformshare"
	storage_account_name	= azurerm_storage_account.lab.name
	quota					= 50
}