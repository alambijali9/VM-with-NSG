resource "azurerm_subnet" "subnet" {
  name                 = "sub-a"
  resource_group_name  = "private-rg"
  virtual_network_name = "vnet1"
  address_prefixes     = ["10.0.1.0/24"]
}