
resource "aws_internet_gateway" "internet_gateway" {
  for_each = {
    for vpc_name, vpc in local.networks : vpc.vpc_index => vpc
    if lookup(vpc, "deploy_internet_gateway", false) == true
  }
  vpc_id = aws_vpc.vpc[each.value.vpc_index].id

  tags = merge(
    { "IaC" = "Terraform" },
    lookup(each.value, "group_tags", {}),
    lookup(each.value, "tags", {}),
  )
}