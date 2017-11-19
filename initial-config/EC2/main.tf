provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "web-demo-ec2" {
  ami = "${var.amazon_linux_ami}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.web-demo-sg.name}"]
  tags {
    Name = "Web Site Demo - Terraform"
  }
  user_data = "${file("user_data.txt")}"
}

resource "aws_security_group" "web-demo-sg" {
  name = "allowweb"
  description = "Allow all inbound http traffic"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
