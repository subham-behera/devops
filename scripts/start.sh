# scripts/start.sh
#!/bin/bash
set -e

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "=== Starting React application ==="

# Ensure proper permissions
log "Setting final permissions..."
chown -R nginx:nginx /var/www/react-vite
find /var/www/react-vite -type d -exec chmod 755 {} \;
find /var/www/react-vite -type f -exec chmod 644 {} \;

# Start Nginx service
log "Starting Nginx service..."
systemctl start nginx
systemctl enable nginx

# Wait for Nginx to start
sleep 3

# Reload Nginx to ensure configuration is applied
log "Reloading Nginx configuration..."
systemctl reload nginx

# Verify Nginx is running
if systemctl is-active --quiet nginx; then
    log "✅ Nginx started successfully"
    
    # Get public IP and display success message
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "unknown")
    if [ "$PUBLIC_IP" != "unknown" ]; then
        log "🌐 Application is available at: http://$PUBLIC_IP"
    else
        log "🌐 Application is running on port 80"
    fi
    
    # Test local connectivity
    if curl -s -o /dev/null -w "%{http_code}" http://localhost/health | grep -q "200"; then
        log "✅ Health check passed"
    else
        log "⚠️  Health check failed, but continuing..."
    fi
    
else
    log "❌ Failed to start Nginx"
    systemctl status nginx --no-pager -l
    exit 1
fi

# Display final status
log "=== Deployment Status ==="
systemctl status nginx --no-pager -l | head -10

log "🚀 React application deployment completed successfully!"