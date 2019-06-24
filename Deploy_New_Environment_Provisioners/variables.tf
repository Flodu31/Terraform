variable "location" {
  default = "westeurope"
}
variable "admin_username" {
  default = "testadmin"
} 
variable "rg_keyvault" {
  default = "Keyvault"
}
variable "keyvault_name" {
  default = "FLOAPP-Keyvault"
}
variable "computer_name_Windows" {
  default = "WS01"
}
variable "rg_network" {
  default = "Network-CloudyJourney-RG"
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