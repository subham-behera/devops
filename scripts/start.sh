#!/bin/bash
echo "Starting app..."
cd /var/www/react-vite
nohup npm run preview -- --port=80 > app.log 2>&1 &
