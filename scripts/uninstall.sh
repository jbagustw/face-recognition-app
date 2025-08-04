#!/bin/bash

# Face Recognition App Uninstall Script

set -e

echo "🗑️ Starting uninstall process..."

# Function to confirm uninstall
confirm_uninstall() {
    echo "⚠️  WARNING: This will completely remove the Face Recognition App and all its data."
    echo "This action cannot be undone!"
    echo ""
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        echo "❌ Uninstall cancelled."
        exit 0
    fi
}

# Function to backup before uninstall
backup_before_uninstall() {
    echo "💾 Creating backup before uninstall..."
    ./scripts/backup.sh
}

# Function to stop running processes
stop_processes() {
    echo "🛑 Stopping running processes..."
    
    # Kill any running npm processes
    pkill -f "npm start" || true
    pkill -f "react-scripts" || true
    
    # Kill any running serve processes
    pkill -f "serve" || true
    
    # Kill any running node processes for this app
    pkill -f "face-recognition-app" || true
    
    echo "✅ Processes stopped"
}

# Function to remove project files
remove_project_files() {
    echo "🗑️ Removing project files..."
    
    # Remove build directory
    if [ -d "build" ]; then
        rm -rf build
        echo "✅ Removed build directory"
    fi
    
    # Remove node_modules
    if [ -d "node_modules" ]; then
        rm -rf node_modules
        echo "✅ Removed node_modules"
    fi
    
    # Remove package-lock.json
    if [ -f "package-lock.json" ]; then
        rm package-lock.json
        echo "✅ Removed package-lock.json"
    fi
    
    # Remove .env files
    rm -f .env.local .env.development.local .env.test.local .env.production.local
    echo "✅ Removed environment files"
    
    # Remove log files
    find . -name "*.log" -type f -delete
    echo "✅ Removed log files"
    
    # Remove cache files
    find . -name ".DS_Store" -type f -delete
    find . -name "Thumbs.db" -type f -delete
    echo "✅ Removed cache files"
}

# Function to remove Docker containers and images
remove_docker() {
    if command -v docker &> /dev/null; then
        echo "🐳 Removing Docker containers and images..."
        
        # Stop and remove containers
        docker stop $(docker ps -q --filter ancestor=face-recognition-app) 2>/dev/null || true
        docker rm $(docker ps -aq --filter ancestor=face-recognition-app) 2>/dev/null || true
        
        # Remove images
        docker rmi face-recognition-app 2>/dev/null || true
        
        echo "✅ Docker containers and images removed"
    fi
}

# Function to remove global packages
remove_global_packages() {
    echo "📦 Removing global packages..."
    
    # Remove Vercel CLI
    npm uninstall -g vercel 2>/dev/null || true
    
    # Remove serve
    npm uninstall -g serve 2>/dev/null || true
    
    # Remove nodemon
    npm uninstall -g nodemon 2>/dev/null || true
    
    echo "✅ Global packages removed"
}

# Function to clean npm cache
clean_npm_cache() {
    echo "🧹 Cleaning npm cache..."
    npm cache clean --force
    echo "✅ npm cache cleaned"
}

# Function to remove git repository
remove_git() {
    if [ -d ".git" ]; then
        echo "📝 Removing git repository..."
        rm -rf .git
        echo "✅ Git repository removed"
    fi
}

# Function to remove backups
remove_backups() {
    if [ -d "backups" ]; then
        echo "🗑️ Removing backups..."
        rm -rf backups
        echo "✅ Backups removed"
    fi
}

# Function to remove scripts
remove_scripts() {
    if [ -d "scripts" ]; then
        echo "🗑️ Removing scripts..."
        rm -rf scripts
        echo "✅ Scripts removed"
    fi
}

# Function to remove documentation
remove_documentation() {
    echo "📚 Removing documentation..."
    rm -f README.md DEPLOYMENT.md CONTRIBUTING.md SECURITY.md CHANGELOG.md LICENSE
    echo "✅ Documentation removed"
}

# Function to remove configuration files
remove_config() {
    echo "⚙️ Removing configuration files..."
    rm -f .eslintrc.json .prettierrc tailwind.config.js postcss.config.js
    rm -f vercel.json nginx.conf docker-compose.yml Dockerfile .dockerignore
    rm -f .github/workflows/ci.yml
    echo "✅ Configuration files removed"
}

# Function to remove source code
remove_source() {
    echo "📁 Removing source code..."
    rm -rf src/
    rm -rf public/
    echo "✅ Source code removed"
}

# Function to remove all remaining files
remove_all_files() {
    echo "🗑️ Removing all remaining files..."
    
    # Remove all files except this script
    find . -maxdepth 1 -type f ! -name "uninstall.sh" -delete
    
    # Remove all directories except current directory
    find . -maxdepth 1 -type d ! -name "." ! -name ".." -exec rm -rf {} +
    
    echo "✅ All files removed"
}

# Function to show uninstall summary
show_summary() {
    echo ""
    echo "🎉 Uninstall completed successfully!"
    echo ""
    echo "📋 What was removed:"
    echo "- ✅ Project files and directories"
    echo "- ✅ Dependencies (node_modules)"
    echo "- ✅ Build files"
    echo "- ✅ Environment files"
    echo "- ✅ Log files"
    echo "- ✅ Cache files"
    echo "- ✅ Docker containers and images"
    echo "- ✅ Global packages"
    echo "- ✅ Git repository"
    echo "- ✅ Backups"
    echo "- ✅ Scripts"
    echo "- ✅ Documentation"
    echo "- ✅ Configuration files"
    echo "- ✅ Source code"
    echo ""
    echo "🧹 Cleanup completed!"
    echo ""
    echo "📝 Note: If you want to reinstall, you can:"
    echo "1. Clone the repository again"
    echo "2. Run './scripts/install.sh'"
    echo "3. Or run 'npm install' and 'npm start'"
    echo ""
    echo "👋 Thank you for using Face Recognition App!"
}

# Main uninstall function
main() {
    echo "🚀 Starting Face Recognition App uninstall..."
    
    # Confirm uninstall
    confirm_uninstall
    
    # Backup before uninstall
    backup_before_uninstall
    
    # Stop running processes
    stop_processes
    
    # Remove project files
    remove_project_files
    
    # Remove Docker containers and images
    remove_docker
    
    # Remove global packages
    remove_global_packages
    
    # Clean npm cache
    clean_npm_cache
    
    # Remove git repository
    remove_git
    
    # Remove backups
    remove_backups
    
    # Remove scripts
    remove_scripts
    
    # Remove documentation
    remove_documentation
    
    # Remove configuration files
    remove_config
    
    # Remove source code
    remove_source
    
    # Remove all remaining files
    remove_all_files
    
    # Show summary
    show_summary
}

# Handle script interruption
trap 'echo "🛑 Uninstall interrupted"; exit 1' INT TERM

# Run main function
main 