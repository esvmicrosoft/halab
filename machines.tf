## Create azure availability set
resource "azurerm_availability_set" "avs_hacluster" {
  name                        = "hacluster-avset"
  location                    = azurerm_resource_group.ha_cluster.location
  resource_group_name         = azurerm_resource_group.ha_cluster.name
  platform_fault_domain_count = 2
}

## Create Jumphost
module "jumphost" {
  source     = "./modules/machines/jumphost"
  depends_on      = [
                     module.ha_network, 
                     azurerm_key_vault_secret.pubkey
                    ]

  server_name     = "${var.prefix}vault${random_id.randomId.hex}"
  resource_group  = azurerm_resource_group.ha_cluster
  nic0_ip         = cidrhost(module.ha_network.subnets_cidrs[0], 4)
  nic0_subnetid   = module.ha_network.subnets_ids[0]
  pubip           = true
  storage_account = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  vaultname       = "${var.prefix}vault${random_id.randomId.hex}"
  publisher       = "canonical"
  offer           = "0001-com-ubuntu-server-jammy"
  sku             = "22_04-lts-gen2"
  image_version   = "latest"
  rsakey          = tls_private_key.rsa-4096-lab
}

## Create Cluster nodes
module "nodes" {
  count = var.number_of_nodes

  source          = "./modules/machines/hanodes"
  depends_on      = [module.ha_network]
  host_instance   = count.index
  server_name     = "${var.hostnames}${count.index}"
  resource_group  = azurerm_resource_group.ha_cluster
  subnets_cidrs   = module.ha_network.subnets_cidrs
  subnets_ids     = module.ha_network.subnets_ids
  cidr_bits       = var.cidr_bits
  storage_account = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  publisher       = var.publisher
  offer           = var.offer
  sku             = var.sku
  image_version   = var.image_version
  avsetid         = azurerm_availability_set.avs_hacluster.id
  rsakey          = tls_private_key.rsa-4096-lab
}


output "jumphost_ip_address" {
  value = module.jumphost.ip_address
}
