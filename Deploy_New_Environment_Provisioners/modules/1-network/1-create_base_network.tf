resource "azurerm_virtual_network" "mgmt_vnet" {
  name                = "FLOAPP-VNet-Test"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  address_space       = ["10.0.0.0/8"]
  dns_servers         = ["8.8.8.8"]
}

resource "azurerm_subnet" "mgmt_sub_db" {
  name                      =   "LAN"
  resource_group_name       =   "${var.rg_network}"
  virtual_network_name      =   "${azurerm_virtual_network.mgmt_vnet.name}"
  address_prefix            =   "10.0.0.0/24"
}
output "mgmt_sub_id" {
  value = "${azurerm_subnet.mgmt_sub_db.id}"
}