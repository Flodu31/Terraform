/* data "azurerm_key_vault_secret" "sql_password" {
  name      = "Passwords"
  vault_uri = "https://ucbsqldemo.vault.azure.net/"
} */

data "azurerm_sql_server" "sqldemo" {
  name                         = "terraformsql01"
  resource_group_name          = "SQL"
}

resource "azurerm_sql_database" "deploy_db" {
  name                = var.db_name
  resource_group_name = "SQL"
  location            = var.location
  server_name         = data.azurerm_sql_server.sqldemo.name
}