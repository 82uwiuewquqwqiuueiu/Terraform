provider "aws" {
region = "ap-south-1"
access_key = "AKIAXB6XBK45SQ4SXJ2A"
secret_key = "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"
}
provider "aws" {
    region = var.region_webserver
}

resource "aws_security_group" "Webserver_SG" {
    name = "Webserver_SG"
    description = "Securty group for Webserver instance"

    ingress {
        from_port = 80
        protocol = "TCP"
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        protocol = "TCP"
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "Webserver_Instance" {
        instance_type = var.type_webserver
        ami = var.ami_webserver
        key_name = "Terraform"
        tags = {
            name = "Webserver_Instance"
        }
        security_groups = ["${aws_security_group.Webserver_SG.name}"]
        user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
}
