variable "location" {
  default = "West US"
}
variable "admin_username" {
  default = "AzureUser"
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
  default = "spcclient-RG"
}

variable "vmsize" {
  description = "VM Size for the Production Environment"
  type        = "string"
  default = "Standard_D2s_v3"


variable "os_ms" {
  description = "Operating System for dev Environment"
  type        = "map"

      default = {
        publisher   =   "MicrosoftWindowsServer"
        offer       =   "WindowsServer"
        sku         =   "2019-Datacenter"
        version     =   "latest"
      }
}
