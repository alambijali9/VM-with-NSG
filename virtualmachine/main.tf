resource "azurerm_public_ip" "pip" {

  name                = "vm-pip"
  resource_group_name = "private-rg"
  location            = "Central India"
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-1"
  location            = "Central India"
  resource_group_name = "private-rg"

  security_rule {
    name                       = "nsg-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface" "nic" {
  name                = "nic-1"
  location            = "Central India"
  resource_group_name = "private-rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/975e136f-8bfa-4d95-9ab6-b679c5858da9/resourceGroups/private-rg/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/sub-a"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg-association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-1"
  resource_group_name             = "private-rg"
  location                        = "Central India"
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "1y^lqs0L5c6C"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
