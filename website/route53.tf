/** Pull domain resource */
data "aws_route53_zone" "website" {
  name = "${var.domain_name}.io"
  private_zone = false
}

/** Create domain resource
resource "aws_route53_zone" "subdomain" {
  name = "${var.sub_domain}.${var.domain_name}.io"
}
*/

/** Create a record to point to the website */
resource "aws_route53_record" "website" {
  zone_id = data.aws_route53_zone.website.zone_id
  name    = var.sub_domain == "" ? "${var.domain_name}.io" : "${var.sub_domain}.${var.domain_name}.io"
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.distribution.domain_name
    zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}