resource "azurerm_resource_group" "rg_compute" {
  name                = "Compute-CloudyJourney"
  location            = "${var.location}"
}
resource "azurerm_network_interface" "windows_nic" {
  name                            = "${var.computer_name_Windows}-NIC"
  location                        = "${var.location}"
  resource_group_name             = "${var.rg_network}"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "windows_vm" {
  name                          = "${var.computer_name_Windows}"
  location                      = "${var.location}"
  resource_group_name           = "${var.rg_network}"
  network_interface_ids         = ["${azurerm_network_interface.windows_nic.id}"]
  vm_size                       = "${var.vmsize["medium"]}"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.os_ms["publisher"]}"
    offer     = "${var.os_ms["offer"]}"
    sku       = "${var.os_ms["sku"]}"
    version   = "${var.os_ms["version"]}"
  }
  storage_os_disk {
    name              = "${var.computer_name_Windows}-OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  os_profile {
    computer_name  = "${var.computer_name_Windows}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_windows_config {
    provision_vm_agent = "true"
    timezone           = "Romance Standard Time"
  }
}

output "computer_name_Windows" {
  value = "${azurerm_virtual_machine.windows_vm.name}"
}
