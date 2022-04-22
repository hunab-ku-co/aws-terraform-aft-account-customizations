data "aws_ec2_transit_gateway" "tgw" {
    # id = data.terraform_remote_state.networking.outputs.ss_infrastructure_tgw_ids[*].ireland_tgw
    id = "tgw-085f17a478f26a2d2"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = [for snet in local.subnets : aws_subnet.subnet[snet.subnet_index].id]
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc["klz-type1"].id
}