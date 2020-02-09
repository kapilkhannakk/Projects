provider "azurerm" {
	version = 1.38
	}
resource "azurerm_storage_account" "lab" {
	name = "statest01"
	resource_group_name = "156-20c72b-deploy-an-azure-storage-account-with-terraform-ajz"
	location = "East US"
	account_tier = "Standard"
	account_replication_type = "LRS"

		tags = {
		 environment = "Terraform Storage"
		 CreatedBy = "Admin"
		 }
}