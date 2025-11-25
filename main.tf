# main.tf


# Configuration du Fournisseur (Provider)

# 1. Configuration du Fournisseur (Provider)

# Indique à Terraform que nous allons interagir avec Azure (azurerm)
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Utilisez une version stable
    }
  }
}

# La configuration du fournisseur azurerm
provider "azurerm" {
  features {} # Utilisation des fonctionnalités par défaut
}


# Création du Groupe de Ressources (Resource Group)

# 2. Création du Groupe de Ressources (Resource Group)

# C'est un conteneur logique pour toutes nos ressources sur Azure
resource "azurerm_resource_group" "rg" {
  # Nom unique pour le Resource Group
  name     = "rg-iac-web-project" 
  # Région, assurez-vous qu'elle est disponible dans votre abonnement
  location = "West Europe" 
}


# Création du Compte de Stockage (Storage Account)

# 3. Création du Compte de Stockage (Storage Account)

# Le nom doit être globalement unique sur tout Azure, d'où la complexité.
# Nous utilisons un nom simple avec 8 caractères aléatoires d'un UUID.
resource "azurerm_storage_account" "sa" {
  name                     = "iacprojectstg${substr(uuid(), 0, 8)}" 
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Stockage localement redondant (le moins cher pour ce projet)
  is_hns_enabled           = false 

}


# Activation de la fonctionnalité "Static Website" sur le Storage Account
resource "azurerm_storage_account_static_website" "static_web" {
  storage_account_id = azurerm_storage_account.sa.id
  

} 

resource "azurerm_storage_account_static_website" "static_web" {
  storage_account_id = azurerm_storage_account.sa.id
  


  # Le nom du fichier d'accueil (page d'index)
  index_document       = "index.html" 
  # Le nom du fichier d'erreur 404
  error_404_document   = "404.html"
}
