packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazonlinux" {
  ami_name      = "packer-linux-aws_{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0f9fc25dd2506cf6d"
  ssh_username  = "ec2-user"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.amazonlinux"
  ]
  
  provisioner "shell" {
    environment_vars = [
      "WORD=Hello World",
    ]
    inline = [
      "#!/bin/bash",
      "yum update -y",
      "yum install -y httpd",
      "systemctl start httpd",
      "systemctl enable httpd",
      "usermod -a -G apache ec2-user",
      "chown -R ec2-user:apache /var/www",
      "chmod 2775 /var/www",
      "echo '<html><h1> $WORD </h1></html>' > /var/www/html/index.html",
    ]
  }
}