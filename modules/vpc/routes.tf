resource "aws_route" "to_tgw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.peer_vpc_cidr
  transit_gateway_id     = var.tgw_id
}

