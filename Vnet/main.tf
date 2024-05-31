resource "azurerm_virtual_network" "network" {
  name                = "vnet1"
  location            = "Central India"
  resource_group_name = "private-rg"
  address_space       = ["10.0.0.0/16"]
 
}