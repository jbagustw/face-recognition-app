#!/bin/bash

# Face Recognition App Cleanup Script

set -e

echo "🧹 Starting cleanup process..."

# Function to confirm action
confirm() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Clean node_modules
if [ -d "node_modules" ]; then
    if confirm "Remove node_modules directory?"; then
        echo "🗑️ Removing node_modules..."
        rm -rf node_modules
        echo "✅ node_modules removed"
    fi
fi

# Clean build directory
if [ -d "build" ]; then
    if confirm "Remove build directory?"; then
        echo "🗑️ Removing build directory..."
        rm -rf build
        echo "✅ build directory removed"
    fi
fi

# Clean cache files
echo "🗑️ Cleaning cache files..."
find . -name "*.log" -type f -delete
find . -name ".DS_Store" -type f -delete
find . -name "Thumbs.db" -type f -delete
find . -name "*.tmp" -type f -delete
find . -name "*.temp" -type f -delete

# Clean npm cache
if confirm "Clear npm cache?"; then
    echo "🗑️ Clearing npm cache..."
    npm cache clean --force
    echo "✅ npm cache cleared"
fi

# Clean git
if [ -d ".git" ]; then
    if confirm "Clean git repository?"; then
        echo "🗑️ Cleaning git repository..."
        git gc --aggressive --prune=now
        echo "✅ git repository cleaned"
    fi
fi

# Clean backups (keep last 5)
if [ -d "backups" ]; then
    if confirm "Clean old backups (keep last 5)?"; then
        echo "🗑️ Cleaning old backups..."
        cd backups
        ls -t *.tar.gz | tail -n +6 | xargs -r rm
        cd ..
        echo "✅ old backups cleaned"
    fi
fi

# Clean Docker (if available)
if command -v docker &> /dev/null; then
    if confirm "Clean Docker images and containers?"; then
        echo "🗑️ Cleaning Docker..."
        docker system prune -f
        echo "✅ Docker cleaned"
    fi
fi

echo "🎉 Cleanup completed successfully!" 