locals {
  #
  # AWS Networking
  #
  config_network  = lookup(local.config, "networks", {})
  network_ranges  = lookup(local.config, "network_ranges", {})
  network_ipam    = lookup(local.config, "ipam", {})
  config_firewall = lookup(local.config, "network_firewall", {})
  groups          = lookup(local.config, "groups", {})
  config_tgw      = lookup(local.config, "transit_gateways", {})
}
