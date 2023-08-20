resource "aws_alb" "application_load_balancer" {
  name               = "apples-prod-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "target_group" {
  name        = "apples-prod-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.little-apples-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "8"
    path                = "/"
    unhealthy_threshold = "3"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}
