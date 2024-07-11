resource "azurerm_resource_group" "cicd" {
  name     = "multi-arch-cicd"
  location = "East US 2"
}

resource "azurerm_kubernetes_cluster" "cicd" {
  name                = "multi-arch-cicd"
  location            = azurerm_resource_group.cicd.location
  resource_group_name = azurerm_resource_group.cicd.name
  dns_prefix          = "multiarchcicd"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    tags = {
      environment = "dev"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "amd64" {
  name                  = "amd64pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cicd.id
  vm_size               = "Standard_DS2_v2" # AMD-based instance
  node_count            = 1
  os_type               = "Linux"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "arm64" {
  name                  = "arm64pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cicd.id
  vm_size               = "Standard_D4ps_v5" # ARM-based instance
  node_count            = 1
  os_type               = "Linux"
  tags = {
    environment = "dev"
  }
}
