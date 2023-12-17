
resource "azurerm_public_ip" "public_ip_address" {
    count    =  var.pubip ? 1 : 0
    name   = "${var.server_name}-public-ip"
    location = var.resource_group.location
    resource_group_name = var.resource_group.name
    allocation_method   = "Static"
    sku                 = "Standard"
    ip_version          = "IPv4"
}

resource "azurerm_network_interface" "nic0" {
  name                    = "${var.server_name}-eth0"
  location                = var.resource_group.location
 resource_group_name     = var.resource_group.name

  ip_configuration {
    name                           = "${var.server_name}-eth0_priv"
    subnet_id                      = var.nic0_subnetid
    private_ip_address_allocation  = "Static"
    private_ip_address             = var.nic0_ip
    primary                        = "true"
    public_ip_address_id           = var.pubip ? azurerm_public_ip.public_ip_address[0].id : null
  }
}

resource "azurerm_linux_virtual_machine" "machine" {
    name                   = var.server_name
    location               = var.resource_group.location
    resource_group_name    = var.resource_group.name
    network_interface_ids  = [azurerm_network_interface.nic0.id]
    size                   = "Standard_D2s_v3"

    computer_name          = var.server_name
    admin_username         = "azureuser"
    custom_data            = filebase64("${path.module}/machine.yml")

    source_image_reference {
      publisher   = var.publisher
      offer       = var.offer
      sku         = var.sku
      version     = var.image_version
    }

    os_disk {
      caching              = "None"
      storage_account_type = "Standard_LRS"
    }

    admin_ssh_key {
      username    = "azureuser"
      public_key  = var.rsakey.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = var.storage_account
    }
    
    identity {
        type = "SystemAssigned"
    }   
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "schedule" {
    virtual_machine_id = azurerm_linux_virtual_machine.machine.id
    location           = azurerm_linux_virtual_machine.machine.location
    enabled            = true 

    daily_recurrence_time = "0000"
    timezone              = "UTC"

    notification_settings {
        enabled     = false
    }
}

output "ip_address" {
  value = var.pubip ? azurerm_public_ip.public_ip_address[0].ip_address : null
}

output "machine" {
  value = azurerm_linux_virtual_machine.machine
}
