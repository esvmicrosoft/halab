## Create Datadisk 
module "datadisk_sbd" {
  count          = var.number_of_nodes / 2

  source         = "./modules/disks/twoshares"
  disk_name      = "sbd${count.index}"
  region         = var.region
  resource_group = azurerm_resource_group.ha_cluster.name
  disk_size      = "4"
}

## Create Datadisk
module "datadisk" {
  count          = var.number_of_nodes

  source         = "./modules/disks/datadisk"
  disk_name      = "datadisk${count.index}"
  region         = var.region
  resource_group = azurerm_resource_group.ha_cluster.name
  disk_size      = "10"
}

## Create Datadisk jumphost to delay actions 
module "jumpdisk" {
  source         = "./modules/disks/datadisk"
  disk_name      = "jumpdisk"
  region         = var.region
  resource_group = azurerm_resource_group.ha_cluster.name
  disk_size      = "4"

  depends_on     = [ azurerm_virtual_machine_data_disk_attachment.sbd_association1 ]

}

## Attach Datadisk to the instance
resource "azurerm_virtual_machine_data_disk_attachment" "sbd_association0" {
  count              = var.number_of_nodes / 2

  managed_disk_id    = module.datadisk_sbd[count.index].disk_id
  virtual_machine_id = module.nodes[count.index*2].machine.id
  lun                = 0
  caching            = "None"
}

## Attach Datadisk to the instance
resource "azurerm_virtual_machine_data_disk_attachment" "sbd_association1" {
  count              = var.number_of_nodes / 2

  managed_disk_id    = module.datadisk_sbd[count.index].disk_id
  virtual_machine_id = module.nodes[count.index*2+1].machine.id
  lun                = 0
  caching            = "None"
}

## Attach Datadisk to the instance
resource "azurerm_virtual_machine_data_disk_attachment" "data_association" {
  count              = var.number_of_nodes
  managed_disk_id    = module.datadisk[count.index].disk_id
  virtual_machine_id = module.nodes[count.index].machine.id
  lun                = 1
  caching            = "None"
}

## Attach Datadisk to the instance
resource "azurerm_virtual_machine_data_disk_attachment" "jump_disk_association" {
  managed_disk_id    = module.jumpdisk.disk_id
  virtual_machine_id = module.jumphost.machine.id
  lun                = 0
  caching            = "None"
}
