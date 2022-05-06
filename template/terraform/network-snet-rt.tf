resource "aws_route_table" "rt" {
  for_each = {
    for subnet in local.subnets : subnet.subnet_index => subnet
    if lookup(subnet.options, "deploy_route_table", false)
  }

  vpc_id = aws_vpc.vpc[each.value.vpc_name].id

  tags = merge(
    { "IaC" = "Terraform" },
    lookup(each.value, "group_tags", {}),
    lookup(each.value, "tags", {}),
  )
}

resource "aws_route_table_association" "rt_association" {
  for_each = {
    for subnet in local.subnets : subnet.subnet_index => subnet
    if lookup(subnet.options, "deploy_route_table", false)
  }
  subnet_id      = aws_subnet.subnet[each.value.subnet_index].id
  route_table_id = aws_route_table.rt[each.value.subnet_index].id
}