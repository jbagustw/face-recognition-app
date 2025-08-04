#!/bin/bash

# Face Recognition App Production Script

set -e

echo "🏭 Starting production build..."

# Set production environment
export NODE_ENV=production

# Clean previous build
if [ -d "build" ]; then
    echo "🧹 Cleaning previous build..."
    rm -rf build
fi

# Install production dependencies
echo "📦 Installing production dependencies..."
npm ci --only=production

# Build the application
echo "🏗️ Building application..."
npm run build

# Check if build was successful
if [ ! -d "build" ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build completed successfully!"

# Optional: Start production server
if [ "$1" = "serve" ]; then
    echo "🌐 Starting production server..."
    echo "📱 App will be available at: http://localhost:3000"
    echo ""
    
    # Install serve if not available
    if ! command -v serve &> /dev/null; then
        echo "📦 Installing serve..."
        npm install -g serve
    fi
    
    serve -s build -l 3000
fi

echo "🎉 Production build completed!" 