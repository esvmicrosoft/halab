
resource "azurerm_managed_disk" "disk" {
    name                   = var.disk_name
    location               = var.region
    resource_group_name    = var.resource_group
    storage_account_type   = "StandardSSD_LRS"
    create_option          = "Empty"
    disk_size_gb           = var.disk_size
    max_shares             = "2"
}

output "disk_id" {
    value = azurerm_managed_disk.disk.id
}

