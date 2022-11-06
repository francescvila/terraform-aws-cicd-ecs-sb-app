#in this template we are creating aws application laadbalancer and target group and alb http listener

resource "aws_alb" "load_balancer" {
  name            = "${var.project_name}-${var.env}"
  subnets         = var.lb_subnets
  security_groups = var.lb_security_groups
}

resource "aws_alb_target_group" "target_group" {
  name        = "${var.project_name}-target-group-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 15
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/"
    interval            = 30
  }

  tags = var.tags
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "lb_listener_http" {
  load_balancer_arn = aws_alb.load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }
}
