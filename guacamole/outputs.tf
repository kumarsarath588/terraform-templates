output "ext-elb-dnsname" {
    value = "${aws_elb.elb-guacamole-web.dns_name}"
}
