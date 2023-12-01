output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = join(",", azurerm_virtual_network.vnet.*.id)
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = join(",", azurerm_virtual_network.vnet.*.name)
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = join(",", azurerm_virtual_network.vnet.*.location)
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.vnet.*.address_space
}

output "vnet_subnets" {
  description = "The ids of subnets created inside the newl vNet"
  value = tomap({
    for k, v in azurerm_subnet.subnet : k => {
      id   = v.id
      name = v.name
    }
  })
}

output "subnet_all" {
  description = "The identifiers of the created Subnets."
  value = {
    for k, v in azurerm_subnet.subnet : k => v
  }
}