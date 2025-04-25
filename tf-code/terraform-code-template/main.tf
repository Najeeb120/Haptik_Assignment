provider "aws" {
region = var.region
}

resource "aws_security_group" "lamp_sg"{
name = "lamp-wordpress"
description = " Allow http,https and SSH

ingress {
description = "Allow HTTP
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "lamp" {
ami = var.ami_id
instance_type = var.instance_type
key_name = var.key_name
security_groups = [aws_security_group.lamp_sg.name]

tags = {
Name = "lamp-wordpress"
}

provisoner "remote-exec" {
inline = [
  " chmod +x /tmp/lamp_wordpress.sh"
  " sudo /tmp/lamp_wordpress.sh ${var.db_name} ${var.db_user}"
]

connection {
type = "ssh"
user = "ubuntu"
private_key = file(var.ssh_private_key_path)
host = self.public_ip
}
}

provisioner "file" {
source = "scripts/lamp_wordpress.sh"
destination = "/tmp/lamp_wordpress.sh"

connection {
type = "ssh"
user = "ubuntu"
private_key = file(var.ssh_private_key_path)
host = self.public_ip
}
}
}




