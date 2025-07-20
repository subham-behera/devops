#!/bin/bash

echo "Stopping React application..."

# Stop Nginx gracefully
if systemctl is-active --quiet nginx; then
    echo "Stopping Nginx..."
    systemctl stop nginx
    echo "✅ Nginx stopped successfully"
else
    echo "ℹ️  Nginx is not running"
fi

# Optional: Clean up old files (uncomment if needed)
# rm -rf /var/www/react-vite/*

echo "Stop script completed"