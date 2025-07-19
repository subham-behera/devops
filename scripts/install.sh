# scripts/install.sh
#!/bin/bash
echo "Installing dependencies..."
cd /var/www/react-vite

# Set proper ownership
chown -R ec2-user:ec2-user /var/www/react-vite

# Install dependencies as ec2-user
sudo -u ec2-user npm install

# If dist folder doesn't exist, build the project
if [ ! -d "dist" ]; then
    echo "Building the application..."
    sudo -u ec2-user npm run build
fi