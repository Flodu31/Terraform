variable "location" {
  description = "Location where to deploy resources"
}
variable "rg_network" {
  description = "Name of the Resource Group where resources will be deployed"
}
variable "computer_name_Windows" {
  description = "Name of the computer"
}
variable "subnet_id" {
  description = "Subnet Id where to join the VM"
}

variable "admin_username" {
  description = "The username associated with the local administrator account on the virtual machine"
}

variable "admin_password" {
  description = "The password associated with the local administrator account on the virtual machine"
}

variable "vmsize" {
  description = "VM Size for the Production Environment"
  type        = "map"

    default = {
      small         =   "Standard_DS1_v2"
      medium        =   "Standard_D2s_v3"
      large         =   "Standard_D4s_v3"
      extralarge    =   "Standard_D8s_v3"
    }
}

variable "os_ms" {
  description = "Operating System for Database (MSSQL) on the Production Environment"
  type        = "map"

    default = {
      publisher   =   "MicrosoftWindowsServer"
      offer       =   "WindowsServer"
      sku         =   "2019-Datacenter"
      version     =   "latest"
    }
}