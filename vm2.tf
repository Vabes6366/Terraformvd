resource "azurerm_network_interface" "example1" {
  name                = "example-nic1"
  location            = azurerm_resource_group.peerrg1.location
  resource_group_name = azurerm_resource_group.peerrg1.name

  ip_configuration {
    name                          = "internal1"
    subnet_id                     = azurerm_subnet.peersubnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example1" {
  name                = "peer-vm12"
  resource_group_name = azurerm_resource_group.peerrg1.name
  location            = azurerm_resource_group.peerrg1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example1.id,
  ]

  availability_set_id = null

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/deshpva/.ssh/key.pub")
  }

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