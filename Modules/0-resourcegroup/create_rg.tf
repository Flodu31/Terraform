resource "azurerm_resource_group" "rg_name" {
  name = var.rg_name
  location = var.location
}