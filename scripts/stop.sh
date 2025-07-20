#!/bin/bash
# Stop any running web servers
pkill -f "serve" || true
pkill -f "http.server" || true