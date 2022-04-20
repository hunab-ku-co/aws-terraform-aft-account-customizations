#! this module is currently only for network interface cards with
#! automaticall assigned private ip

resource "aws_network_interface" "private_nic" {
  for_each = {
    for subnet in local.subnets : subnet.subnet_index => subnet
    if lookup(subnet.options, "deploy_nic", false)
  }
  subnet_id         = aws_subnet.subnet[each.value.subnet_index].id

  tags = merge(
    { "IaC" = "Terraform" },
    lookup(each.value, "group_tags", {}),
    lookup(each.value, "tags", {}),
  )
}