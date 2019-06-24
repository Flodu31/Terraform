// Create Resource Group
resource "azurerm_resource_group" "rg_network" {
  name                = "${var.rg_network}"
  location            = "${var.location}"
}
// Create Network
module "create_network" {
  source                    = "./modules/1-network"
  location                  = "${azurerm_resource_group.rg_network.location}"
  rg_network                = "${azurerm_resource_group.rg_network.name}"
}
// Get Keyvault Data
data "azurerm_resource_group" "rg_keyvault" {
  name                = "${var.rg_keyvault}"
}
data "azurerm_key_vault" "keyvault" {
  name                = "${var.keyvault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg_keyvault.name}"
}
data "azurerm_key_vault_secret" "secret_Default-Admin-Windows-Linux-VM" {
  name      = "Default-Admin-Windows-Linux-VM"
  vault_uri = "${data.azurerm_key_vault.keyvault.vault_uri}"
}
// Create Windows VM
module "windows_vm" {
  source                    = "./modules/2-windows_vm"
  computer_name_Windows     = "${var.computer_name_Windows}"
  rg_network                = "${azurerm_resource_group.rg_network.name}"
  subnet_id                 = "${module.create_network.mgmt_sub_id}"
  location                  = "${azurerm_resource_group.rg_network.location}"
  vmsize                    = "${var.vmsize}"
  os_ms                     = "${var.os_ms}"
  admin_username            = "${var.admin_username}"
  admin_password            = "${data.azurerm_key_vault_secret.secret_Default-Admin-Windows-Linux-VM.value}"
}

output "PIP" {
  value = "${module.windows_vm.pip_Windows}"
}
