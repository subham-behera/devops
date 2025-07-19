# scripts/start.sh
#!/bin/bash
echo "Starting the application..."
cd /var/www/react-vite

# Start the application in the background as ec2-user
sudo -u ec2-user nohup npm run preview -- --host 0.0.0.0 --port 3000 > app.log 2>&1 &

# Wait a moment for the app to start
sleep 10

# Check if the app is running
if pgrep -f "npm run preview" > /dev/null; then
    echo "Application started successfully"
else
    echo "Failed to start application"
    exit 1
fi