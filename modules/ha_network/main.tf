
resource "azurerm_network_security_group"  "split_network_nsg" {
  name                          = "${var.network_name}-vnet-NSG-CASG"
  location                      = var.region
  resource_group_name           = var.resource_group

  security_rule {
    name                        = "ssh"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_address_prefix       = "${var.localip}/32"
    source_port_range           = "*"
    destination_address_prefix  = "*"
    destination_port_range      = "22"
  }

  tags = {
    environment = "Terraform single network"
  }
}

resource "azurerm_virtual_network" "split_network" {
  name                = var.network_name
  address_space       = ["${var.cidr}"]
  location            = var.region
  resource_group_name = var.resource_group

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "subnets" {
  count = pow(2, parseint(var.cidr_bits,10))

  name                  = "subnet${count.index}"
  resource_group_name   = var.resource_group
  virtual_network_name  = azurerm_virtual_network.split_network.name
  address_prefixes      = [
              cidrsubnet(azurerm_virtual_network.split_network.address_space[0],parseint(var.cidr_bits,10),count.index)
    ]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count = pow(2, parseint(var.cidr_bits,10))

  subnet_id                 =  azurerm_subnet.subnets[count.index].id
  network_security_group_id =  azurerm_network_security_group.split_network_nsg.id
}


output "network_name" {
  description = "Name of virtual network"
  value       = azurerm_virtual_network.split_network.name
}

output "network_id" {
  description = "Virtual network ID"
  value       = azurerm_virtual_network.split_network.id
}

output "subnets_names" {
  description  = "Name of the virtual subnets"
  value        = azurerm_subnet.subnets[*].name
}

output "subnets_cidrs" {
  description = "CIDR of the subnets"
  value       = azurerm_subnet.subnets[*].address_prefixes[0]
}

output "subnets_ids" {
  description = "ID of subnets Id"
  value       = azurerm_subnet.subnets[*].id
}

