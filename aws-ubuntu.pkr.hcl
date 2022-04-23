packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-linux-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
  provisioner "shell" {
    environment_vars = [
      "WORD=Hello World",
    ]
    inline = [
      "#!/bin/bash",
      "apt-get update",
      "apt-get install -y apache2",
      "cat <<EOF > /var/www/index.html",
      "<html><body><h1>$WORD</h1></body></html>",
      "EOF",
    ]
  }
}