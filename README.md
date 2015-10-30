# terraform-templates
Infrastructure as code terraform templates


This templates can be used as a modules of can be cloned and executed  directly by passing variabels.
This templates as of now supports only aws as a provider.
In order to import these modules into your template. create example.tf file with,

module "database-mysql" {
    source = "github.com/kumarsarath588/terraform-templates/database-mysql"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    db_name = "guacamole"
    db_username = "guacamole"
    db_password = "guacamole"
}

output "db" {
    value = "${module.database.db_address}"
}

As our configuration is completed we need to add some vaiables like access_key and secret key.

As you can see that i am using them as variables because i don't want to hardcode in my configuration file, you can give then in above configuration or you can create variables.tf file with,

variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "ap-southeast-1"
}

Now, your config is ready its time to plan our configuration

`terraform get` to download the module from git.
`terraform plan` to plan and also it show shows what all resources exists and instances gets created. this requires AWS keys, if you dont have one create now.
`terraform apply` finally to create the instances in AWS.

Note: You can also save the keys in terrafrom.tfvars file and execute the above commands.

access_key = "foo"
secret_key = "foo"


