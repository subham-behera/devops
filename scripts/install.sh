# scripts/install.sh
#!/bin/bash
set -e

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "=== Installing React application ==="

# Ensure Nginx is installed (fallback)
if ! command -v nginx &> /dev/null; then
    log "Installing Nginx..."
    amazon-linux-extras install nginx1 -y || yum install nginx -y
fi

# Create application directory
log "Creating application directory..."
mkdir -p /var/www/react-vite

# Backup existing nginx.conf if it exists
if [ -f /etc/nginx/nginx.conf ]; then
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
fi

# Create main Nginx configuration
log "Creating Nginx configuration..."
cat > /etc/nginx/nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                   '$status $body_bytes_sent "$http_referer" '
                   '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 4096;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    include /etc/nginx/conf.d/*.conf;
}
EOF

# Create React app configuration
log "Creating React app Nginx configuration..."
cat > /etc/nginx/conf.d/react-app.conf << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    
    root /var/www/react-vite;
    index index.html;
    
    # Handle React Router (SPA routing)
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    
    # Health check endpoint for CodeDeploy
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF

# Remove default configurations that might conflict
rm -f /etc/nginx/conf.d/default.conf
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

# Set proper ownership and permissions
log "Setting permissions..."
chown -R nginx:nginx /var/www/react-vite
chmod -R 755 /var/www/react-vite

# Create a default index.html if none exists (temporary)
if [ ! -f /var/www/react-vite/index.html ]; then
    log "Creating temporary index.html..."
    cat > /var/www/react-vite/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>React Vite App - Deploying...</title>
</head>
<body>
    <h1>React Vite App</h1>
    <p>Application is being deployed...</p>
</body>
</html>
EOF
    chown nginx:nginx /var/www/react-vite/index.html
fi

# Test Nginx configuration
log "Testing Nginx configuration..."
nginx -t || {
    log "❌ Nginx configuration test failed"
    exit 1
}

log "✅ Installation completed successfully"
