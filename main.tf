resource "azurerm_resource_group" "rg" {
  name      = "${var.resource_group_name}_${var.environment}"
  location  = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  dns_servers         = []
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = [
    "Microsoft.Storage"
  ]
}

resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "random_string" "sa" {
  length  = 10
  upper   = false
  special = false
}
#Allow access from YOUR_Org_name and the vnet
resource "azurerm_storage_account" "storage_account" {
  name                      = random_string.sa.result
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = "true"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = [
      "198.203.177.177",
      "198.203.175.175",
      "198.203.181.181",
      "168.183.84.12",
      "149.111.26.128",
      "149.111.28.128",
      "149.111.30.128",
      "220.227.15.70",
      "203.39.148.18",
      "161.249.192.14",
      "161.249.72.14",
      "161.249.80.14",
      "161.249.96.14",
      "161.249.144.14",
      "161.249.176.14",
      "161.249.16.0/23",
      "12.163.96.0/24",
    ]
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "blob"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
