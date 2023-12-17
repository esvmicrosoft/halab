
resource "azurerm_key_vault_secret" "resourcegroup" {
  name         = "resourcegroup"
  value        = azurerm_resource_group.ha_cluster.name
  key_vault_id = azurerm_key_vault.ha_cluster.id
}

resource "azurerm_key_vault_secret" "subscriptionid" {
  name         = "subscriptionid"
  value        = data.azurerm_client_config.current.subscription_id
  key_vault_id = azurerm_key_vault.ha_cluster.id
}

resource "azurerm_key_vault_secret" "first_node" {
  name         = "firstnode"
  value        = module.nodes[0].machine.name
  key_vault_id = azurerm_key_vault.ha_cluster.id
}

resource "azurerm_key_vault_secret" "machines_list" {
  name         = "machineslist"
  value        = join(",", module.nodes[*].machine.name)
  key_vault_id = azurerm_key_vault.ha_cluster.id
}

resource "azurerm_key_vault_secret" "privkey" {
  name         = "privkey"
  value        = tls_private_key.rsa-4096-lab.private_key_openssh
  key_vault_id = azurerm_key_vault.ha_cluster.id
}

resource "azurerm_key_vault_secret" "pubkey" {
  name         = "pubkey"
  value        = tls_private_key.rsa-4096-lab.public_key_openssh
  key_vault_id = azurerm_key_vault.ha_cluster.id
}

resource "azurerm_key_vault_secret" "serviceip" {
  name         = "serviceip"
  value        = cidrhost(module.ha_network.subnets_cidrs[0], -2)
  key_vault_id = azurerm_key_vault.ha_cluster.id
}

