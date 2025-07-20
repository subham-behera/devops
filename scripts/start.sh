#!/bin/bash
cd /var/www/react-vite

# Kill any existing processes
pkill -f "serve"

# Start the application using a static server
npx serve -s dist -l 80 &

# Or if you prefer using Python's simple server:
# cd dist && python3 -m http.server 80 &