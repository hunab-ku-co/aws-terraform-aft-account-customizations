locals {
  #
  # Enrich network configuration with location and resource group name
  #
  networks = {
    for network_name, network in local.config_network : network_name => merge(
      {
        vpc_index           = network_name,
        vpc_name            = network_name,
        firewall_definition = lookup(network, "network_firewall", null),
        group_metadata      = lookup(lookup(local.groups, lookup(network, "group", "group-not-defined"), {}), "metadata", {}),
        group_tags          = lookup(lookup(local.groups, lookup(network, "group", "group-not-defined"), {}), "tags", {}),
      },
      network
    )
    if lookup(local.config_network, "network", null) == null
  }
}

resource "aws_vpc" "vpc" {
  for_each = {
    for vpc_name, vpc in local.networks : vpc.vpc_index => vpc
    if lookup(local.networks, "networks", null) == null && lookup(vpc, "existing_resource", null) == null
  }
  cidr_block                       = each.value.cidr_block
  instance_tenancy                 = each.value.instance_tenancy
  enable_dns_hostnames             = each.value.enable_dns_hostnames
  enable_dns_support               = each.value.enable_dns_support
  assign_generated_ipv6_cidr_block = each.value.assign_generated_ipv6_cidr_block
  tags = merge(
    { "IaC" = "Terraform" },
    lookup(each.value, "group_tags", {}),
    lookup(each.value, "tags", {}),
  )
}

output "ss_infrastructure_vpc_ids" {
  value = { for vpc in local.networks : vpc.vpc_name => aws_vpc.vpc[vpc.vpc_index].id }
}