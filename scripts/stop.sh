# scripts/stop.sh
#!/bin/bash
echo "Stopping existing application..."
pkill -f "npm run preview" || true
sleep 5