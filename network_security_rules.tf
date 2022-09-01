
resource "azurerm_network_security_rule" "deny_all_outbound" {
  name                        = "DenyAllOutboundTraffic"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  description                 = "Denies all outbound traffic."
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  access                      = "Deny"
  priority                    = "4096"
  direction                   = "Outbound"
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "DenyAllInboundTraffic"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  description                 = "Denies all inbound traffic."
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  access                      = "Deny"
  priority                    = "4095"
  direction                   = "Inbound"
}

resource "azurerm_network_security_rule" "allow_inbound_azure_load_balancer" {
  name                        = "AllowInboundAzureLoadBalancer"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  description                 = "Allow inbound access from Azure Load Balancer."
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  access                      = "Allow"
  priority                    = "1000"
  direction                   = "Inbound"
}

resource "azurerm_network_security_rule" "YOUR_Org_name_network_security_rule" {
  name                        = "AllowYOUR_Org_nameHttpsInbound"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"

  # http://ecc.YOUR_Org_name.com/hideaddresses.htm
  source_address_prefixes = [
    "12.163.96.0/24",
    "149.111.26.128/32",
    "149.111.28.128/32",
    "149.111.30.128/32",
    "161.249.144.14/32",
    "161.249.16.0/23",
    "161.249.176.14/32",
    "161.249.192.14/32",
    "161.249.72.14/32",
    "161.249.80.14/32",
    "161.249.96.14/32",
    "198.203.175.175/32",
    "198.203.177.177/32",
    "198.203.181.181/32",
    "203.39.148.18/32",
    "220.227.15.70/32",
  ]

  destination_address_prefix = "*"
  access                     = "Allow"
  priority                   = "200"
  direction                  = "Inbound"
}

resource "azurerm_network_security_rule" "allow_azurecloud_outbound" {
  name                        = "AllowAzureCloudOutbound"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  description                 = "Azure Cloud Outbound rule."
  protocol                    = "*"
  destination_port_ranges     = ["443", "9000"] # Add 22 for AKS deployment
  source_port_range           = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureCloud.${var.location}"
  access                      = "Allow"
  priority                    = "4002"
  direction                   = "Outbound"
}

resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  name                        = "vnet_inbound"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name

  priority                   = 1500
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  name                        = "vnet_outbound"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name

  priority                   = 1501
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "VirtualNetwork"
}
