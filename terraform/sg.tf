resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  vpc_id = aws_vpc.little-apples-vpc.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "apples_task_sg" {
  name_prefix = "apples_task_sg-"
  vpc_id = aws_vpc.little-apples-vpc.id
  ingress {
    from_port = 80
    to_port = 5000
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "flask_sg" {
    name_prefix = "flask-sg-"
    vpc_id = aws_vpc.little-apples-vpc.id
    ingress {
        from_port = 80
        to_port = 5000
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    ingress {
        from_port = 80
        to_port = 5000
        protocol = "tcp"
        security_groups = [aws_security_group.apples_task_sg.id]
    }
}

resource "aws_security_group" "mongo_sg" {
    name_prefix = "mongo-sg-"
    vpc_id = aws_vpc.little-apples-vpc.id
    ingress {
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
        security_groups = [aws_security_group.flask_sg.id]
    }

     ingress {
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        security_groups = [aws_security_group.apples_task_sg.id]
    }
}

resource "aws_security_group" "ecs_cluster_sg" {
  name_prefix = "ecs-cluster-sg-"
  vpc_id = aws_vpc.little-apples-vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    self        = true  
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
}


