data "aws_ec2_transit_gateway" "tgw" {
    # id = data.terraform_remote_state.networking.outputs.ss_infrastructure_tgw_ids[*].ireland_tgw
    id = "tgw-085f17a478f26a2d2"
}