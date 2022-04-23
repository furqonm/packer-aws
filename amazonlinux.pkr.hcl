packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_id" {
  type    = string
  default = "ami-0f9fc25dd2506cf6d"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "version" {
  type    = string
  default = "0.1"
}

source "amazon-ebs" "amazonlinux" {
  source_ami    = "${var.ami_id}"
  region        = "${var.region}"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "packer-linux-aws_{{timestamp}}"
  tags = {
    Name = "AmazonLinux 2.0.${var.version}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
  }
}

build {
  name    = "build-packer"
  sources = [
    "source.amazon-ebs.amazonlinux"
  ]
  
  provisioner "shell" {
    environment_vars = [
      "WORD=Hello World",
    ]
    inline = [
      "#!/bin/bash",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www",
      "echo '<html><h1> $WORD </h1></html>' > /var/www/html/index.html",
    ]
  }
  provisioner "file" {
    source      = "./"
    destination = "/var/www/html/"
  }
}