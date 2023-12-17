## Fetch client configuration
data "azurerm_client_config" "current" {}

## Create Key vault in azure
resource "azurerm_key_vault" "ha_cluster" {
  name                = "${var.prefix}vault${random_id.randomId.hex}"
  location            = azurerm_resource_group.ha_cluster.location
  resource_group_name = azurerm_resource_group.ha_cluster.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false

  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = "7bc11cb5-11ed-4aed-8926-3f4f7b66c28a"
    secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  }

  access_policy {
    tenant_id           = data.azurerm_client_config.current.tenant_id
    object_id           = data.azurerm_client_config.current.object_id
    key_permissions     = []
    secret_permissions  = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    storage_permissions = []
  }
}

resource "azurerm_key_vault_access_policy" "jumphost" {
  key_vault_id = azurerm_key_vault.ha_cluster.id
  tenant_id    = module.jumphost.machine.identity[0].tenant_id
  object_id    = module.jumphost.machine.identity[0].principal_id

  secret_permissions = [
    "Get", "List", "Delete", "Purge",
  ]
}

## Assign Virtual Machine contributor Role
resource "azurerm_role_assignment" "machine_contributor" {
  count = var.number_of_nodes
  scope = azurerm_resource_group.ha_cluster.id
  # Virtual Machine Contributor
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = module.nodes[count.index].machine.identity[0].principal_id
}

