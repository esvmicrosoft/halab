
resource "azurerm_network_interface" "nics" {
  count = pow(2, parseint(var.cidr_bits, 10))

  name                    = "${var.server_name}-eth${count.index}"
  location                = var.resource_group.location
  resource_group_name     = var.resource_group.name

  ip_configuration {
    name                           = "${var.server_name}-eth${count.index}_priv"
    subnet_id                      = var.subnets_ids[count.index]
    private_ip_address_allocation  = "Static"
    private_ip_address             = cidrhost(var.subnets_cidrs[count.index],6+var.host_instance)
    primary                        = "true"
  }
}



data "template_cloudinit_config" "config" {
  gzip           = true
  base64_encode  = true

  part {
    content_type  = "text/cloud-config"
    content       = file("${path.module}/machine.yaml")
  }
}

resource "azurerm_linux_virtual_machine" "machine" {
    name                   = var.server_name
    location               = var.resource_group.location
    resource_group_name    = var.resource_group.name
    network_interface_ids  = azurerm_network_interface.nics[*].id
    size                   = "Standard_D2s_v3"
    custom_data            = data.template_cloudinit_config.config.rendered

    computer_name          = var.server_name
    admin_username         = "azureuser"
    availability_set_id    = var.avsetid

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

output "machine" {
  value = azurerm_linux_virtual_machine.machine
}

output "nics" {
  value = azurerm_network_interface.nics
}

