resource "aws_acm_certificate" "www" {
  provider          = aws.acm
  domain_name       = local.fqdn
  validation_method = "DNS"
  tags              = var.tags
}

resource "aws_acm_certificate_validation" "www" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.www.arn
  validation_record_fqdns = [for r in aws_route53_record.www_cert_validation : r.fqdn]
}

