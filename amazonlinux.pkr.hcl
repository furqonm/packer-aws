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
}