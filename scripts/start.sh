#!/bin/bash

echo "Starting React application..."

# Ensure proper permissions
chown -R nginx:nginx /var/www/react-vite
chmod -R 755 /var/www/react-vite

# Start Nginx service
systemctl start nginx
systemctl enable nginx

# Reload Nginx to pick up any configuration changes
systemctl reload nginx

# Check if Nginx is running
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx started successfully"
    echo "🌐 Application should be available at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
else
    echo "❌ Failed to start Nginx"
    systemctl status nginx
    exit 1
fi

# Display status
systemctl status nginx --no-pager -l