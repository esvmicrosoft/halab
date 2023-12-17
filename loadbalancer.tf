## Create Azure Load Balancer
resource "azurerm_lb" "cluster_lb" {
  name                = "${var.prefix}-cluster-lb"
  location            = azurerm_resource_group.ha_cluster.location
  resource_group_name = azurerm_resource_group.ha_cluster.name
  sku                 = "Standard"
  sku_tier            = "Regional"

  dynamic "frontend_ip_configuration" {
    for_each = range(var.number_of_nodes / 2)
    iterator = each

    content {
      name                          = "frontend_ip_config${each.value}"
      subnet_id                     = module.ha_network.subnets_ids[0]
      private_ip_address            = cidrhost(module.ha_network.subnets_cidrs[0], -2-each.value)
      private_ip_address_allocation = "Static"
      private_ip_address_version    = "IPv4"
  
    }
  }
}

## Create Load Balancer Probe
resource "azurerm_lb_probe" "check_http" {
  name            = "check_http"
  loadbalancer_id = azurerm_lb.cluster_lb.id
  port            = "61000"
  protocol        = "Tcp"
}

module "backend_pool_config" {
  count = var.number_of_nodes / 2

  source = "./modules//network/lb_backend_pool"
  depends_on = [ azurerm_lb.cluster_lb, azurerm_lb_probe.check_http ]
  
  index              = count.index
  load_balancer      = azurerm_lb.cluster_lb
  machines           = [ for i in range(count.index*2,count.index*2+2): module.nodes[i] ]
  network            = module.ha_network
  frontend_ip_config = azurerm_lb.cluster_lb.frontend_ip_configuration[count.index].name
  check_http         = azurerm_lb_probe.check_http

}
