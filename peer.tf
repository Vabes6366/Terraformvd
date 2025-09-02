resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.peerrg.name
  virtual_network_name      = azurerm_virtual_network.peervnet1.name
  remote_virtual_network_id = azurerm_virtual_network.peervnet2.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.peerrg1.name
  virtual_network_name      = azurerm_virtual_network.peervnet2.name
  remote_virtual_network_id = azurerm_virtual_network.peervnet1.id
}