#!/bin/bash

# Check if Apache is installed
if ! command -v httpd &> /dev/null; then
  echo "Installing Apache (httpd)..."
  yum install -y httpd
fi

# Stop Apache service before deployment
systemctl stop httpd