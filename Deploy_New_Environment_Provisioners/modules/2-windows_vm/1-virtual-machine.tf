resource "azurerm_resource_group" "rg_compute" {
  name                = "Compute-CloudyJourney-RG"
  location            = "${var.location}"
}
resource "azurerm_public_ip" "windows_pip" {
  name                = "${var.computer_name_Windows}-PIP"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  allocation_method   = "Static"
}
resource "azurerm_network_security_group" "windows_nsg" {
  name                = "${var.computer_name_Windows}-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "WinRM"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface" "windows_nic" {
  name                            = "${var.computer_name_Windows}-NIC"
  location                        = "${var.location}"
  resource_group_name             = "${var.rg_network}"
  network_security_group_id       = "${azurerm_network_security_group.windows_nsg.id}"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id            = "${azurerm_public_ip.windows_pip.id}"
  }
}

resource "azurerm_virtual_machine" "windows_vm" {
  name                          = "${var.computer_name_Windows}"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg_compute.name}"
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
    custom_data    = "${file("./files/winrm.ps1")}"
  }
  os_profile_windows_config {
    provision_vm_agent = "true"
    timezone           = "Romance Standard Time"
    winrm {
      protocol = "http"
    }
    # Auto-Login's required to configure WinRM
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    }
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = "${file("./files/FirstLogonCommands.xml")}"
    }
  }
  provisioner "remote-exec" {
    connection {
      host     = "${azurerm_public_ip.windows_pip.ip_address}"
      type     = "winrm"
      port     = 5985
      https    = false
      timeout  = "5m"
      user     = "${var.admin_username}"
      password = "${var.admin_password}"
    }
    inline = [
      "powershell.exe -ExecutionPolicy Unrestricted -Command {Install-WindowsFeature -name Web-Server -IncludeManagementTools}",
    ]
}
}

output "computer_name_Windows" {
  value = "${azurerm_virtual_machine.windows_vm.name}"
}
output "pip_Windows" {
  value = "${azurerm_public_ip.windows_pip.ip_address}"
}