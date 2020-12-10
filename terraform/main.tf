# RG

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# AKS and ACR 

resource "azurerm_container_registry" "acr" {
  name                     = var.container_registr_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = true
}

resource "azurerm_kubernetes_cluster" "wtaks" {
  name                = "wtaks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "wellnesstrace"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }
  
  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  tags = {
    Environment = "Workshop"
  }
}

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "wtaks_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.wtaks.kubelet_identity[0].object_id
}


# My SQL

resource "azurerm_mysql_server" "wtmysql" {
  name                = var.mysql_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = var.wtsql_administrator_login
  administrator_login_password = var.wtsql_administrator_login_password

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
}

resource "azurerm_mysql_database" "wtdb" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.wtmysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "firewall" {
  name                = "mysql_firewall"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.wtmysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}