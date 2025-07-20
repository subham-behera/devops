#!/bin/bash

# Create Nginx configuration for React app
cat > /etc/nginx/conf.d/react-app.conf << 'EOF'
server {
    listen 80;
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
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

# Remove default Nginx configuration
rm -f /etc/nginx/conf.d/default.conf
rm -f /etc/nginx/sites-enabled/default

# Create application directory if it doesn't exist
mkdir -p /var/www/react-vite

# Set proper permissions
chown -R nginx:nginx /var/www/react-vite
chmod -R 755 /var/www/react-vite

# Test Nginx configuration
nginx -t

echo "Installation completed successfully"