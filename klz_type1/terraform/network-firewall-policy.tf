

# resource "aws_networkfirewall_firewall_policy" "tgw_hub_fw_policy" {
#   for_each = {
#     for vpc_name, vpc in local.networks : vpc_name => vpc
#     if lookup(vpc, "firewall_definition", null) != null
#   }
#   name = each.value.network_firewall.firewall_name

#   firewall_policy {
#     stateless_default_actions          = ["aws:pass"]
#     stateless_fragment_default_actions = ["aws:drop"]
#     # stateless_rule_group_reference {
#     #   priority     = 1
#     #   resource_arn = aws_networkfirewall_rule_group.example.arn
#     # }
#   }

#   tags = merge(
#     { "IaC" = "Terraform" },
#     lookup(each.value, "group_tags", {}),
#     lookup(each.value, "tags", {}),
#   )
# }
