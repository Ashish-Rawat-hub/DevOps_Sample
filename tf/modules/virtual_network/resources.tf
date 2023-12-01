
resource "azurerm_virtual_network" "vnet" {
  count               = var.create ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.vnet_location
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each                                       = { for snet in var.subnets : snet.subnet_name => snet }
  name                                           = each.value.subnet_name
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = join(",", azurerm_virtual_network.vnet.*.name) == "" ? var.vnet_name : join(",", azurerm_virtual_network.vnet.*.name)
  address_prefixes                               = each.value.address_prefixes
  service_endpoints                              = each.value.subnet_service_endpoints
  depends_on                                     = [azurerm_virtual_network.vnet]
  enforce_private_link_endpoint_network_policies = try(each.value.enforce_private_link_endpoint_network_policies, false)

  dynamic "delegation" {
    for_each = try(each.value.service_delegation_serverFarms, false) ? [1] : []

    content {
      name = "Microsoft.Web.serverFarms"
      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  #for_each            = {for snet in var.subnets : snet.subnet_name => snet if var.nsg_rules != null || try(snet.nsg_rules != null, false)}
  count               = var.create ? 1 : 0
  name                = var.nsg_name
  location            = var.vnet_location
  resource_group_name = var.resource_group_name
  dynamic "security_rule" {
    for_each = try(length(var.nsg_rules), 0) > 0 ? [
      for n in var.nsg_rules : {
        name                       = n.name
        priority                   = n.priority
        direction                  = n.direction
        access                     = n.access
        protocol                   = n.protocol
        source_port_range          = n.source_port_range
        destination_port_range     = n.destination_port_range
        source_address_prefix      = n.source_address_prefix
        source_address_prefixes    = n.source_address_prefixes
        destination_address_prefix = n.destination_address_prefix
      }
    ] : [
      for n in var.nsg_rules : {
        name                       = n.name
        priority                   = n.priority
        direction                  = n.direction
        access                     = n.access
        protocol                   = n.protocol
        source_port_range          = n.source_port_range
        destination_port_range     = n.destination_port_range
        source_address_prefix      = n.source_address_prefix
        source_address_prefixes    = n.source_address_prefixes
        destination_address_prefix = n.destination_address_prefix
      }
    ]
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      source_address_prefixes    = security_rule.value.source_address_prefixes
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
  depends_on          = [azurerm_virtual_network.vnet, azurerm_subnet.subnet]
  tags                = var.tags
  lifecycle {
    ignore_changes = [security_rule]
  }
}

resource "azurerm_subnet_network_security_group_association" "snet-nsg-association" {
  for_each                  = {for snet in var.subnets : snet.subnet_name => snet if var.nsg_rules != null || try(snet.nsg_rules != null, false)}
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = join(",", azurerm_network_security_group.nsg.*.id) == "" ? var.nsg_id : join(",", azurerm_network_security_group.nsg.*.id)
  depends_on                = [azurerm_network_security_group.nsg, azurerm_subnet.subnet]
}