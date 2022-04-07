# -------------------------------- Certificate creating ------------------------------------|

resource "aws_acm_certificate" "cert" {
  domain_name       = var.your_dns_name
  validation_method = "DNS"

  subject_alternative_names = ["*.${var.your_dns_name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "my_cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.my_cert : record.fqdn]
}