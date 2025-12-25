resource "time_sleep" "wait_for_tgw" {
  depends_on = [
    module.kor_vpc,
    module.usa_vpc,
    aws_ec2_transit_gateway_peering_attachment.kor_to_usa
  ]

  create_duration = "180s"
}
