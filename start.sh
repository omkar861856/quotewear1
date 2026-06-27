#!/bin/bash

echo "🚀 Starting Deployment Process..."

# 1. Bring down any existing containers
echo "🛑 Stopping existing containers..."
docker compose down

# 2. Start the database and Redis first
echo "🗄️ Starting Database and Redis..."
docker compose up -d postgres redis

# Give the database a few seconds to initialize
echo "⏳ Waiting 10 seconds for database to be ready..."
sleep 10

# 3. Start the Backend
echo "⚙️ Starting Backend API..."
docker compose up -d backend

# Give the backend time to start up before the storefront builds
echo "⏳ Waiting 15 seconds for backend to start..."
sleep 15

# 4. Build and Start the Storefront
# By building the storefront AFTER the backend is running, we ensure
# Next.js can connect to it (if network access is configured)
echo "🛍️ Building and Starting Storefront..."
docker compose up -d --build storefront

# 5. Start the Nginx Proxy
echo "🌐 Starting Nginx Proxy..."
docker compose up -d proxy

echo "✅ All services started successfully!"
echo "🌍 Storefront: http://localhost (or your server IP/domain on port 80)"
echo "🔧 Admin Panel: http://localhost:9000/app"
