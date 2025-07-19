#!/bin/bash
cd /home/ec2-user/react-vite-app
# Install serve if not already
npm install -g serve
# Kill any process running on port 3000
fuser -k 3000/tcp || true
# Start the React app using `serve` in background
serve -s dist -l 3000 &
