provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}
/* This resource creates elastic load balancer for guacamole
    with internal subnets of TechM VPC which listens on 80 port 
    and redirects to 8080 port of guacamole application servers */
	
resource "aws_elb" "elb-guacamole-app" {
  name = "elb-guacamole-app"
  subnets = ["subnet-fd57d78a","subnet-d4da43b1"]
  internal = true
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8080/guacamole/"
    interval = 30
  }
  security_groups = ["sg-2f1e684a"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "elb-guacamole-app"
  }
}

/* This resource creates load balancer cookie stickiness policy,
   which allows an ELB to control the sticky session lifetime 
   of the browser */
   
resource "aws_lb_cookie_stickiness_policy" "elb-stickness-guacamole-app" {
      name = "elb-stickness-guacamole-app"
      load_balancer = "${aws_elb.elb-guacamole-app.id}"
      lb_port = 80
      cookie_expiration_period = 600
}

/* This resource create a aws auto scaling launch configuration 
with ami image of guacamole app spinning up t2.micro instance. */

resource "aws_launch_configuration" "as-conf-guacamole-app" {
	name = "as-conf-guacamole-app"
    image_id = "ami-eda7608e"
    instance_type = "t2.small"
	key_name = "309342"
	security_groups = [ "sg-8b85f5ee"]
    lifecycle {
      create_before_destroy = true
    }
}

/* This resource create a aws autoscaling group in TechM vpc private 
   subnets with min instances of 2 and max instaces of 4 */
   
resource "aws_autoscaling_group" "asg-guacamole-app" {
  name = "asg-guacamole-app"
  vpc_zone_identifier = ["subnet-fd57d78a", "subnet-d4da43b1"]
  max_size = 4
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.as-conf-guacamole-app.name}"
  load_balancers = ["${aws_elb.elb-guacamole-app.name}"]

  tag {
    key = "name"
    value = "guacmole-app"
    propagate_at_launch = true
  }
}

/* This resource creates elastic load balancer for guacamole webserver
   with internal subnets of TechM VPC which listens on 80 port 
   and redirects to guacamole app internal load balancer */

resource "aws_elb" "elb-guacamole-web" {
  name = "elb-guacamole-web"
  subnets = ["subnet-fcda4399","subnet-2857d75f"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/guacamole/"
    interval = 30
  }
  security_groups = ["sg-2f1e684a"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  tags {
    Name = "elb-guacamole-web"
  }
}

/* This resource creates external load balancer cookie stickiness policy,
   which allows an ELB to control the sticky session lifetime 
   of the browser */

resource "aws_lb_cookie_stickiness_policy" "elb-stickness-guacamole-web" {
      name = "elb-stickness-guacamole-web"
      load_balancer = "${aws_elb.elb-guacamole-web.id}"
      lb_port = 80
      cookie_expiration_period = 600
}

resource "template_file" "guacamole_sh" {
    filename = "guacamole.sh"
    vars {
        elb = "${aws_elb.elb-guacamole-app.dns_name}"
    }
}
/* This resource create a aws auto scaling launch configuration 
with ami image of guacamole web spinning up t2.micro instance. */

resource "aws_launch_configuration" "as-conf-guacamole-web" {
    name = "as-conf-guacamole-web"
    image_id = "ami-95ae69f6"
    instance_type = "t2.small"
    key_name = "309342"
    security_groups = [ "sg-2f1e684a"]
    user_data = "${template_file.guacamole_sh.rendered}"
    lifecycle {
      create_before_destroy = true
    }
}

/* This resource create a aws autoscaling group in TechM vpc private 
   subnets with min instances of 2 and max instaces of 4 */
resource "aws_autoscaling_group" "asg-guacamole-web" {
  name = "asg-guacamole-web"
  vpc_zone_identifier = ["subnet-fcda4399","subnet-2857d75f"]
  max_size = 4
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.as-conf-guacamole-web.name}"
  load_balancers = ["${aws_elb.elb-guacamole-web.name}"]

  tag {
    key = "name"
    value = "guacmole-web"
    propagate_at_launch = true
  }
}
