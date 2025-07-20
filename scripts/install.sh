#!/bin/bash
# Create application directory if it doesn't exist
mkdir -p /var/www/react-vite

# Install or update Node.js dependencies if needed
cd /var/www/react-vite

# Set proper permissions
chown -R ec2-user:ec2-user /var/www/react-vite
chmod -R 755 /var/www/react-vite