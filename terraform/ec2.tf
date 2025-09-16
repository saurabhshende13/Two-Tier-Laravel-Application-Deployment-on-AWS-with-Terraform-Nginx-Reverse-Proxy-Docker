########################################
# Nginx EC2 (Tier 1 - public subnet)
########################################
resource "aws_instance" "nginx" {
  ami                         = var.nginx_ami
  instance_type               = var.nginx_instance_type
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              cat > /etc/nginx/sites-available/default <<EOT
              server {
                  listen 80;
                  location / {
                      proxy_pass http://${aws_lb.int_alb.dns_name};
                      proxy_http_version 1.1;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto $scheme;
                  }
              }
              EOT
              systemctl restart nginx
              EOF

  tags = { Name = "${var.project}-nginx" }
}

########################################
# App AutoScaling Group (Tier 2 - private subnet)
########################################
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project}-app-laraval"
  image_id      = var.app_ami
  instance_type = var.app_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              cd /home/ubuntu/Larevel-app
              docker compose up -d
              EOF
  )
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.private1.id]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]
  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "${var.project}-app"
    propagate_at_launch = true
  }
}
