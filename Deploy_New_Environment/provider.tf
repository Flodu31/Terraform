provider "azurerm" {
  subscription_id = "la souscription où déployer les ressources"
  client_id       = "l'application id qui a les droits pour déployer des ressources"
  client_secret   = "le mot de passe associé"
  tenant_id       = "l'id de votre tenant Azure AD"
}