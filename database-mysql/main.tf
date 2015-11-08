provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_security_group" "db-sg" {
  name = "db-sg"
  description = "Database Instance sg"

  ingress {
      from_port = 3306
      to_port = 0
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "db" {
    identifier = "mysql-rds"
    allocated_storage = "${var.db_storage}"
    engine = "${var.db_engine}"
    engine_version = "${var.db_engine_version}"
    instance_class = "${var.db_instance_type}"
    name = "${var.db_name}"
    username = "${var.db_username}"
    password = "${var.db_password}"
    multi_az = "${var.multiaz}"
    db_subnet_group_name = "${var.db_subnet_group}"
    parameter_group_name = "default.mysql5.6"
    port = "${var.db_port}"	
    vpc_security_group_ids = [ "${aws_security_group.db-sg.id}" ]
}
