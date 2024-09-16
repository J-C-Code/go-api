terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.2.0"
    }
  }
}


provider "azurerm" {
    resource_provider_registrations = "none"
    features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "TEST"
  location = "centralus"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name                = "aks1"
    location            = azurerm_resource_group.aks_rg.location
    resource_group_name = azurerm_resource_group.aks_rg.name
    dns_prefix          = "aks1"

    default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v5"
    }

    identity {
    type = "SystemAssigned"
    }

    tags = {
    environment = "Testing"
    }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}
