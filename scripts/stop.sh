# scripts/stop.sh
#!/bin/bash
set -e

echo "=== Stopping React application ==="

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Stop Nginx gracefully
if systemctl is-active --quiet nginx; then
    log "Stopping Nginx..."
    systemctl stop nginx || {
        log "Failed to stop Nginx gracefully, forcing stop..."
        systemctl kill nginx
        sleep 2
    }
    log "✅ Nginx stopped successfully"
else
    log "ℹ️  Nginx is not running"
fi

# Wait a moment for processes to fully stop
sleep 2

log "Stop script completed successfully"
exit 0