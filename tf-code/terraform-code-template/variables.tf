variable "region" {
default = "us-east-1"
}


variable "instance-type" {
default = "t2.micro"
}

variable "key_name" {
description = " Name of existing key pair"
}

variable "ssh_private_key_path"{
description = "path to private key"
}

variable "ami_id"  {
description = "AMI ID of Ubuntu"
}

variable "db_name" {
default = "wordpress_db"
}

variable "db_user" {
default = "test-user"
}



