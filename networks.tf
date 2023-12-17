

module "ha_network" {
  source         = "./modules/ha_network"
  network_name   = "ha_network"
  region         = var.region
  resource_group = azurerm_resource_group.ha_cluster.name
  localip        = var.localip
  cidr           = "10.0.1.0/24"
  cidr_bits      = var.cidr_bits
}


resource "azurerm_public_ip" "natgw_publicip" {
  name                = "nat-gateway-publicIP"
  location            = azurerm_resource_group.ha_cluster.location
  resource_group_name = azurerm_resource_group.ha_cluster.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "cluster_gw" {
  name                    = "ha_cluster_gw"
  location                = azurerm_resource_group.ha_cluster.location
  resource_group_name     = azurerm_resource_group.ha_cluster.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "cluster_gw_ip" {
  nat_gateway_id       = azurerm_nat_gateway.cluster_gw.id
  public_ip_address_id = azurerm_public_ip.natgw_publicip.id
}

resource "azurerm_route_table" "cluster_udrs" {
  name                          = "cluster_routes_udr"
  location                      = azurerm_resource_group.ha_cluster.location
  resource_group_name           = azurerm_resource_group.ha_cluster.name
  disable_bgp_route_propagation = false

  route {
    name           = "tothenatgw"
    address_prefix = "${azurerm_public_ip.natgw_publicip.ip_address}/32"
    next_hop_type  = "Internet"
  }
}
