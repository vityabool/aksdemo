output "client_certificate" {
  value = azurerm_kubernetes_cluster.wtaks.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.wtaks.kube_config_raw
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "mysql_fqdn" {
  value = azurerm_mysql_server.wtmysql.fqdn
}