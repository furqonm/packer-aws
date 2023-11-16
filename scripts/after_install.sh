#!/bin/bash

# Start Apache service after deployment
systemctl start httpd

# Check if there is text in the HTML file
if grep -q "AWS Workshop" /var/www/html/index.html; then
  echo "Text found in HTML file."
else
  echo "Error: No text found in HTML file!"
  exit 1  # Exit with a non-zero status to indicate failure
fi