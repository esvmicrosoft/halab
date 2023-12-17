

## Create Azure Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backend_address_pool" {

  name            = "Backend_Address_Pool${var.index}"
  loadbalancer_id = var.load_balancer.id

}

### Create Azure Load Balancer Backend Address Pool address
resource "azurerm_lb_backend_address_pool_address" "lb_ipconfig" {
  count                   = length(var.machines)

  name                    = "ipconfig${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool.id
  virtual_network_id      = var.network.network_id
  ip_address              = var.machines[count.index].machine.private_ip_address

}

## Create Load Balancer rule
resource "azurerm_lb_rule" "http_rule" {

  name                           = "http_rule${var.index}"
  loadbalancer_id                = var.load_balancer.id
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_address_pool.id]
  probe_id                       = var.check_http.id
  frontend_ip_configuration_name = var.frontend_ip_config
}

