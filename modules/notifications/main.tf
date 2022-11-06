data "template_file" "cloudformation_sns_stack" {
  template = file("${path.module}/templates/email-sns-stack.json.tpl")

  vars = {
    display_name = "${var.project_name}-${var.env}-bot"
    subscriptions = join(
      ",",
      formatlist(
        "{ \"Endpoint\": \"%s\", \"Protocol\": \"%s\"  }",
        var.sns_email_addresses,
        var.sns_protocol
      )
    )
  }
}

resource "aws_cloudformation_stack" "sns_topic" {
  name          = "${var.project_name}-${var.sns_stack_name}-${var.env}"
  template_body = data.template_file.cloudformation_sns_stack.rendered
  tags = var.tags
}
