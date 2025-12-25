resource "aws_ec2_transit_gateway" "kor" {
  provider    = aws.seoul
  description = "KOR Transit Gateway"

  tags = {
    Name = "TGW-KOR"
  }
}

resource "aws_ec2_transit_gateway" "usa" {
  provider    = aws.oregon
  description = "USA Transit Gateway"

  tags = {
    Name = "TGW-USA"
  }
}
