locals {
  subnet_custom_routes = (flatten(
    [
      for subnet in local.subnets : [
        for route_name, route in lookup(subnet, "routes", {}) : {
          route_index                = join("_", [route_name, subnet.subnet_index])
          subnet_index               = subnet.subnet_index
          subnet_name                = subnet.subnet_name
          route_name                 = route_name
          destination_cidr_block     = lookup(route, "destination_cidr_block", null)
          destination_prefix_list_id = lookup(route, "destination_prefix_list_id", null)
          gateway_id                 = lookup(route, "gateway_id", null)
          nat_gateway_id             = lookup(route, "nat_gateway_id", null)
          network_interface_id       = lookup(route, "network_interface_id", null)
          transit_gateway_id         = lookup(route, "transit_gateway_id", null)
          vpc_endpoint_id            = lookup(route, "vpc_endpoint_id", null)
          vpc_peering_connection_id  = lookup(route, "vpc_peering_connection_id", null)
        }
        if lookup(subnet.options, "route_table", true)
      ]
  ]))
}

resource "aws_route" "route" {
  for_each = {
    for route in local.subnet_custom_routes : route.route_index => route
    #* try to check if the cidr block prefix is valid
    # if can(regex("^(?:(?:1?\\d?\\d|2[0-4]\\d|25[0-5])\\.){3}(?:1?\\d?\\d|2[0-4]\\d|25[0-5])\\/(1[6-9]|2[0-8])$", route.destination_cidr_block))
  }
  route_table_id             = aws_route_table.rt[each.value.subnet_index].id
  destination_cidr_block     = each.value.destination_cidr_block
  destination_prefix_list_id = each.value.destination_prefix_list_id
  gateway_id                 = each.value.gateway_id
  nat_gateway_id             = each.value.nat_gateway_id
  network_interface_id       = each.value.network_interface_id
  transit_gateway_id         = each.value.transit_gateway_id
  vpc_endpoint_id            = each.value.vpc_endpoint_id
  vpc_peering_connection_id  = each.value.vpc_peering_connection_id
}
