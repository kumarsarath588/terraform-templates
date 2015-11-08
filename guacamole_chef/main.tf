# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}
module "database" {
    source = "github.com/kumarsarath588/terraform-templates/database-mysql"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    db_name = "guacamole_db"
    db_username = "guacamole_user"
    db_password = "guacamole"
}
resource "aws_security_group" "guac-app-sg" {
  name = "guac-app-sg"
  description = "Guacamole Instance security group"

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a web server
resource "aws_instance" "web" {
    ami = "ami-52978200"
    instance_type = "t2.small"
    security_groups = [ "${aws_security_group.guac-app-sg.name}" ]
    tags {
        Name = "prov_guacamole"
    }
    key_name = "309342"
    provisioner "chef"  {
        attributes {
                "java" {
                   "jdk_version" = 8
                   "install_flavor" = "oracle"
		   "oracle" { 
                       "accept_oracle_download_terms" = true
                   }
                }
                "guacamole" {
                  "dbhost" = "${module.database.db_address}"
                }
        }
        environment = "_default"
        run_list = ["guacamole"]
        node_name = "${aws_instance.web.private_dns}"
        server_url = "https://ip-172-31-23-211.ap-southeast-1.compute.internal/organizations/techm-dev"
        validation_client_name = "techm-dev-validator"
        validation_key_path = "techm-dev-validator.pem"
        version = "12.4.1"
        ssl_verify_mode = ":verify_none"
        connection {
        user = "ec2-user"
        key_file = "/etc/ansible/309342.pem"
        }
    }
}
