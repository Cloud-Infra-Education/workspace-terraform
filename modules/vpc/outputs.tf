output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "private_route_table_ids" {
  value = [aws_route_table.private.id]
}

output "public_route_table_ids" {
  value = [aws_route_table.public.id]
}

output "vpc_id" {
  value = aws_vpc.this.id
}
