resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sto" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "stocontainer" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.sto.name
  container_access_type = "private"
}

resource "azurerm_hdinsight_hbase_cluster" "hd" {
  name                = var.hbase_cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cluster_version     = "3.6"
  tier                = "Standard"

  component_version {
    hbase = "1.1"
  }

  gateway {
    enabled  = true
    username = var.ambari_user_name
    password = var.ambari_password
  }

  storage_account {
    storage_container_id = azurerm_storage_container.stocontainer.id
    storage_account_key  = azurerm_storage_account.sto.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = "Standard_D3_V2"
      username = var.ssh_user_name
      password = var.ssh_password
    }

    worker_node {
      vm_size               = "Standard_D3_V2"
      username              = var.ssh_user_name
      password              = var.ssh_password
      target_instance_count = 1
    }

    zookeeper_node {
      vm_size  = "Standard_D3_V2"
      username = var.ssh_user_name
      password = var.ssh_password
    }
  }
}

output "httpsendpoint" {
    value = azurerm_hdinsight_hbase_cluster.hd.https_endpoint
}

output "sshendpoint" {
    value = azurerm_hdinsight_hbase_cluster.hd.ssh_endpoint
}

