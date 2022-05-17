locals {
  subnets = flatten([
    for vpc_name, vpc in local.networks : [
      for subnet_name, subnet in vpc.subnets : merge({
        vpc_index               = vpc.vpc_index
        vpc_name                = vpc_name
        subnet_index            = join("_", [vpc_name, subnet_name])
        subnet_name             = subnet_name
        availability_zone       = lookup(vpc, "availability_zone", null)
        vpc_metadata            = lookup(vpc, "metadata", {})
        vpc_tags                = lookup(vpc, "tags", {})
        vpc_routes              = lookup(vpc, "routes", {})
        deploy_nat_gateway      = lookup(lookup(subnet, "options", {}), "deploy_nat_gateway", false)
        deploy_network_firewall = lookup(lookup(subnet, "options", {}), "deploy_aws_network_firewall", true)
        sg                      = lookup(lookup(subnet, "options", {}), "security_group", true)
        attach_to_tgw           = lookup(subnet, "attach_to_tgw", false)
        group_metadata          = lookup(vpc, "group_metadata", {})
        group_tags              = lookup(vpc, "group_tags", {})
        },
      subnet)
      if vpc.subnets != null
    ]
  ])
}

resource "aws_subnet" "subnet" {
  for_each = {
    for subnet in local.subnets : subnet.subnet_index => subnet
  }
  vpc_id                                         = aws_vpc.vpc[each.value.vpc_index].id
  availability_zone                              = each.value.availability_zone
  cidr_block                                     = each.value.cidr_block
  enable_dns64                                   = each.value.enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = each.value.enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = each.value.enable_resource_name_dns_a_record_on_launch
  private_dns_hostname_type_on_launch            = each.value.private_dns_hostname_type_on_launch

  tags = merge(
    { "IaC" = "Terraform" },
    lookup(each.value, "group_tags", {}),
    lookup(each.value, "tags", {}),
  )
}

output "ss_infrastructure_subnet_ids" {
  value = { for snet in local.subnets : snet.subnet_name => aws_subnet.subnet[snet.subnet_index].id }
}
