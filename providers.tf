terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.111.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }
}

provider "azurerm" {
    skip_provider_registration = true
    features {}
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.cicd.kube_config[0].host
    username               = azurerm_kubernetes_cluster.cicd.kube_config[0].username
    password               = azurerm_kubernetes_cluster.cicd.kube_config[0].password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.cicd.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.cicd.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cicd.kube_config[0].cluster_ca_certificate)
  }
}