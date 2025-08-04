#!/bin/bash

# Face Recognition App Update Script

set -e

echo "🔄 Starting update process..."

# Function to backup before update
backup_before_update() {
    echo "💾 Creating backup before update..."
    ./scripts/backup.sh
}

# Function to check for updates
check_for_updates() {
    echo "🔍 Checking for updates..."
    
    # Check npm outdated packages
    echo "📦 Checking npm packages..."
    npm outdated || true
    
    # Check git status
    if [ -d ".git" ]; then
        echo "📝 Checking git status..."
        git status --porcelain
    fi
}

# Function to update dependencies
update_dependencies() {
    echo "📦 Updating dependencies..."
    
    # Update npm packages
    npm update
    
    # Update global packages
    npm update -g npm
    npm update -g vercel
    
    echo "✅ Dependencies updated"
}

# Function to update git repository
update_git() {
    if [ -d ".git" ]; then
        echo "📝 Updating git repository..."
        
        # Check if there are uncommitted changes
        if [ -n "$(git status --porcelain)" ]; then
            echo "⚠️  Uncommitted changes detected. Stashing..."
            git stash
        fi
        
        # Pull latest changes
        git pull origin main
        
        # Restore stashed changes if any
        if git stash list | grep -q "stash@{0}"; then
            echo "📝 Restoring stashed changes..."
            git stash pop
        fi
        
        echo "✅ Git repository updated"
    fi
}

# Function to rebuild application
rebuild_app() {
    echo "🏗️ Rebuilding application..."
    
    # Clean previous build
    if [ -d "build" ]; then
        rm -rf build
    fi
    
    # Install dependencies
    npm install
    
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

# Function to run tests
run_tests() {
    echo "🧪 Running tests..."
    npm test -- --coverage --watchAll=false
    echo "✅ Tests passed"
}

# Function to run linting
run_linting() {
    echo "🔍 Running linting..."
    npm run lint
    echo "✅ Linting passed"
}

# Function to check security
check_security() {
    echo "🔒 Checking security..."
    npm audit --audit-level=moderate
    echo "✅ Security check completed"
}

# Main update function
main() {
    echo "🚀 Starting Face Recognition App update..."
    
    # Backup before update
    backup_before_update
    
    # Check for updates
    check_for_updates
    
    # Update git repository
    update_git
    
    # Update dependencies
    update_dependencies
    
    # Rebuild application
    rebuild_app
    
    # Run tests
    run_tests
    
    # Run linting
    run_linting
    
    # Check security
    check_security
    
    echo ""
    echo "🎉 Update completed successfully!"
    echo ""
    echo "📋 What was updated:"
    echo "- Dependencies (npm packages)"
    echo "- Application code (git pull)"
    echo "- Build files (rebuilt)"
    echo "- Tests (re-run)"
    echo "- Security audit (completed)"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Run 'npm start' to test the updated app"
    echo "2. Check if all features work correctly"
    echo "3. Deploy if everything looks good"
    echo ""
    echo "📚 Documentation:"
    echo "- Check CHANGELOG.md for recent changes"
    echo "- Review DEPLOYMENT.md for deployment"
    echo "- Read CONTRIBUTING.md for contributions"
}

# Handle script interruption
trap 'echo "🛑 Update interrupted"; exit 1' INT TERM

# Run main function
main 