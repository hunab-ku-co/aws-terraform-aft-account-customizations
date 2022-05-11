# As a result of this, local.subnets_availability_zones will be a map from availability zone name
# to a list of one or more subnet ids, like this:
# {
#   "az1-a" = ["subnetid1", "subnetid4"]
#   "az1-b" = ["subnetid2"]
#   "az1-c" = ["subnetid3"]
# }
locals {
  subnets_availability_zones = {
    for snet in local.subnets : snet.availability_zone => aws_subnet.subnet[snet.subnet_index].id...
  }
}

data "aws_ec2_transit_gateway" "tgw" {
    # id = data.terraform_remote_state.networking.outputs.ss_infrastructure_tgw_ids[*].ireland_tgw
    id = "tgw-085f17a478f26a2d2"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = [ for snet_ids in local.subnets_availability_zones : snet_ids[0] ]
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc["klz-type1"].id
}

