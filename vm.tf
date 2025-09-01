resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.peerrg.location
  resource_group_name = azurerm_resource_group.peerrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.peersubnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "peer-vm1"
  resource_group_name = azurerm_resource_group.peerrg.name
  location            = azurerm_resource_group.peerrg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
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