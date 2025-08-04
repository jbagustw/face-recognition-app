#!/bin/bash

# Face Recognition App Restart Script

set -e

echo "🔄 Starting restart process..."

# Function to stop running processes
stop_processes() {
    echo "🛑 Stopping running processes..."
    
    # Kill any running npm processes
    pkill -f "npm start" 2>/dev/null || true
    pkill -f "react-scripts" 2>/dev/null || true
    
    # Kill any running serve processes
    pkill -f "serve" 2>/dev/null || true
    
    # Kill any running node processes for this app
    pkill -f "face-recognition-app" 2>/dev/null || true
    
    # Wait a moment for processes to stop
    sleep 2
    
    echo "✅ Processes stopped"
}

# Function to clean cache
clean_cache() {
    echo "🧹 Cleaning cache..."
    
    # Clear npm cache
    npm cache clean --force
    
    # Remove node_modules if requested
    if [ "$1" = "--clean" ]; then
        echo "🗑️ Removing node_modules..."
        rm -rf node_modules
        rm -f package-lock.json
    fi
    
    echo "✅ Cache cleaned"
}

# Function to reinstall dependencies
reinstall_deps() {
    echo "📦 Reinstalling dependencies..."
    
    # Install dependencies
    npm install
    
    echo "✅ Dependencies reinstalled"
}

# Function to rebuild application
rebuild_app() {
    echo "🏗️ Rebuilding application..."
    
    # Clean previous build
    if [ -d "build" ]; then
        rm -rf build
    fi
    
    # Build application
    npm run build
    
    # Test build
    if [ -d "build" ]; then
        echo "✅ Application rebuilt successfully"
    else
        echo "❌ Build failed"
        exit 1
    fi
}

# Function to start application
start_app() {
    echo "🚀 Starting application..."
    
    # Start development server
    npm start &
    
    # Wait for server to start
    sleep 5
    
    # Check if server is running
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "✅ Application started successfully"
        echo "📱 App is available at: http://localhost:3000"
    else
        echo "❌ Failed to start application"
        exit 1
    fi
}

# Function to show restart summary
show_summary() {
    echo ""
    echo "🎉 Restart completed successfully!"
    echo ""
    echo "📋 What was done:"
    echo "- ✅ Stopped running processes"
    echo "- ✅ Cleaned cache"
    echo "- ✅ Reinstalled dependencies"
    echo "- ✅ Rebuilt application"
    echo "- ✅ Started application"
    echo ""
    echo "🌐 Application is now running at: http://localhost:3000"
    echo ""
    echo "📊 Status:"
    echo "- Development server: Running"
    echo "- Build: Successful"
    echo "- Dependencies: Updated"
    echo ""
    echo "🔧 Next steps:"
    echo "1. Open http://localhost:3000 in your browser"
    echo "2. Allow camera access when prompted"
    echo "3. Test face recognition features"
    echo ""
    echo "🛠️ Available commands:"
    echo "- npm start - Start development server"
    echo "- npm run build - Build for production"
    echo "- npm test - Run tests"
    echo "- ./scripts/help.sh - Show help"
}

# Main restart function
main() {
    echo "🚀 Starting Face Recognition App restart..."
    
    # Stop running processes
    stop_processes
    
    # Clean cache
    clean_cache "$1"
    
    # Reinstall dependencies
    reinstall_deps
    
    # Rebuild application
    rebuild_app
    
    # Start application
    start_app
    
    # Show summary
    show_summary
}

# Handle script interruption
trap 'echo "🛑 Restart interrupted"; exit 1' INT TERM

# Check if clean restart is requested
if [ "$1" = "--clean" ]; then
    echo "🧹 Clean restart requested"
    main "--clean"
else
    main
fi 