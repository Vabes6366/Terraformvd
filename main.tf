terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.37.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstate2207"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = "4c0e37c0-6ce9-4f7a-b165-37ef3b6c5bfd"
}

resource "azurerm_resource_group" "peerrg" {
  name     = "peerrg"
  location = "East US"
}

resource "azurerm_resource_group" "peerrg1" {
  name     = "peerrg1"
  location = "East US"
}

resource "azurerm_virtual_network" "peervnet1" {
  name                = "peervnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.peerrg.location
  resource_group_name = azurerm_resource_group.peerrg.name
}

resource "azurerm_subnet" "peersubnet1" {
  name                 = "peersubnet"
  resource_group_name  = azurerm_resource_group.peerrg.name
  virtual_network_name = azurerm_virtual_network.peervnet1.name
  address_prefixes     = ["10.0.0.0/20"]
}

resource "azurerm_network_security_group" "peernsg1" {
  name                = "peernsg"
  location            = azurerm_resource_group.peerrg.location
  resource_group_name = azurerm_resource_group.peerrg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "peersubnetnsgassoc1" {
  subnet_id                 = azurerm_subnet.peersubnet1.id
  network_security_group_id = azurerm_network_security_group.peernsg1.id
}

resource "azurerm_virtual_network" "peervnet2" {
  name                = "peervnet2"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.peerrg1.location
    resource_group_name = azurerm_resource_group.peerrg1.name
}

resource "azurerm_subnet" "peersubnet2" {
  name                 = "peersubnet2"
  resource_group_name  = azurerm_resource_group.peerrg1.name
  virtual_network_name = azurerm_virtual_network.peervnet2.name
  address_prefixes     = ["10.1.0.0/20"]
}

resource "azurerm_subnet_network_security_group_association" "peersubnetnsgassoc2" {
  subnet_id                 = azurerm_subnet.peersubnet2.id
  network_security_group_id = azurerm_network_security_group.peernsg1.id
}

