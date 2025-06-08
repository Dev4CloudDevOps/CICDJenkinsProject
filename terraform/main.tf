provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "boardgame_rg" {
  name     = "boardgame-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "boardgame_vnet" {
  name                = "boardgame-vnet"
  location            = azurerm_resource_group.boardgame_rg.location
  resource_group_name = azurerm_resource_group.boardgame_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "boardgame_subnet" {
  name                 = "boardgame-subnet"
  resource_group_name  = azurerm_resource_group.boardgame_rg.name
  virtual_network_name = azurerm_virtual_network.boardgame_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "boardgame_nsg" {
  name                = "boardgame-nsg"
  location            = azurerm_resource_group.boardgame_rg.location
  resource_group_name = azurerm_resource_group.boardgame_rg.name

  security_rule {
    name                       = "Allow-SMTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "25"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Custom-Range-1"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000-10000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Custom-Range-2"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30000-32767"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Custom-6443"
    priority                   = 700
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SMTPS"
    priority                   = 800
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "465"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "boardgame_nic" {
  name                = "boardgame-nic"
  location            = azurerm_resource_group.boardgame_rg.location
  resource_group_name = azurerm_resource_group.boardgame_rg.name
  subnet_id           = azurerm_subnet.boardgame_subnet.id

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.boardgame_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "boardgame_vm" {
  count               = 5
  name                = "boardgame-vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.boardgame_rg.name
  location            = azurerm_resource_group.boardgame_rg.location
  size                = "Standard_B2ms"
  admin_username      = "azureuser"
  admin_password      = "P@ssw0rd1234"
  network_interface_ids = [
    azurerm_network_interface.boardgame_nic.id,
  ]

  os_disk {
    name                 = "boardgame-os-disk-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "Terraform"
  }
}

output "security_group_id" {
  value = azurerm_network_security_group.boardgame_nsg.id
}
