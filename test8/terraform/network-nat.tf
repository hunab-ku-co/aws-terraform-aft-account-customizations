#! current implementation only for private nat gw
resource "aws_nat_gateway" "private_nat_gw" {
  for_each = {
    for subnet in local.subnets : subnet.subnet_index => subnet
    if lookup(subnet.options, "deploy_nat_gateway", false)
  }
  connectivity_type = "private"
  subnet_id         = aws_subnet.subnet[each.value.subnet_index].id

  tags = merge(
    { "IaC" = "Terraform" },
    lookup(each.value, "group_tags", {}),
    lookup(each.value, "tags", {}),
  )
}
