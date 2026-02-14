resource "aws_alb" "elb_vote" {
  name            = local.elb.names.vote
  internal        = false
  subnets         = [for s in data.aws_subnets.default_subnets.ids : s]
  idle_timeout    = 4000
  security_groups = [aws_security_group.main_sg.id]
}

resource "aws_alb" "elb_result" {
  name            = local.elb.names.result
  internal        = false
  subnets         = [for s in data.aws_subnets.default_subnets.ids : s]
  idle_timeout    = 4000
  security_groups = [aws_security_group.main_sg.id]
}

resource "aws_alb_target_group" "elb_vote_tg" {
  name        = local.elb.names.vote
  port        = "5000"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default_vpc.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "45"
    protocol            = "HTTP"
    matcher             = "200-404"
    timeout             = "10"
    path                = "/"
    unhealthy_threshold = "4"
  }
}

resource "aws_alb_listener" "elb_vote_listener" {
  load_balancer_arn = aws_alb.elb_vote.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.elb_vote_tg.id
    type             = "forward"
  }
}

resource "aws_alb_target_group" "elb_result_tg" {
  name        = local.elb.names.result
  port        = "5001"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default_vpc.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "45"
    protocol            = "HTTP"
    matcher             = "200-404"
    timeout             = "10"
    path                = "/"
    unhealthy_threshold = "4"
  }
}

resource "aws_alb_listener" "elb_result_listener" {
  load_balancer_arn = aws_alb.elb_result.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.elb_result_tg.id
    type             = "forward"
  }
}
