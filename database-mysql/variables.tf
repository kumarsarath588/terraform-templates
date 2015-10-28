variable "access_key" {}
variable "secret_key" {}

variable "region" {
    default = "ap-southeast-1"
}

variable "db_name" {
    description = "Initial DB name, DB is not created if not specified"
}

variable "db_engine" {
    default = "mysql"
    description = "DB engine name, default is mysql"
}

variable "db_engine_version" {
    default = "5.6.23"
    description = "DB engine version, default only for mysql"
}

variable "db_instance_type" {
    default = "db.t1.micro"
    description = "DB instance type/class"
}

variable "db_username" {
    default = "mysql"
    description = "DB username"
}

variable "db_password" {
    default = "mysql"
    description = "DB password"
}

variable "db_subnet_group" {
    default = "default"
    description = "DB Subnet group"
}

variable "db_port" {
    default = 3306
    description = "DB port number"
}

variable "multiaz" {
    default = true
    description = "Multi AZ enable disable"
}

variable "db_storage" {
    default = 5
    description = "Multi AZ enable disable"
}

variable "db_sg_cidr" {
    default = "0.0.0.0/0"
    description = "RDS security group cidr default is from anywhere"
}
