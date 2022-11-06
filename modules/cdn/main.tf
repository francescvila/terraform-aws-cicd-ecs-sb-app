# Cloudfront

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = var.target_domain_name
    origin_id   = var.origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    origin_shield {
      enabled              = true
      origin_shield_region = var.aws_region
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  # attach the WAF when an Id is given
  #   web_acl_id = length(var.waf_id) == 0 ? null : var.waf_id

  comment = "${var.project_name} ${var.env} CloudFront distribuition"
  # default_root_object = "index.html"

  #   logging_config {
  #     include_cookies = false
  #     bucket          = "${var.project_name}-${var.env}-logs.s3.amazonaws.com"
  #     prefix          = "${var.project_name}-${var.env}"
  #   }

  #aliases = ["mysite.example.com", "yoursite.example.com"]
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id
    compress         = true

    forwarded_values {
      query_string = true
      # headers      = ["Origin", "Accept-Language"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 120
    max_ttl     = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      #    restriction_type = "whitelist"
      #    locations        = ["US", "CA", "GB", "DE"]
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # viewer_certificate {
  #   cloudfront_default_certificate = false
  #   minimum_protocol_version       = "TLSv1.2_2021"
  #   acm_certificate_arn            = var.certificate_arn
  #   ssl_support_method             = "sni-only"
  # }
}
