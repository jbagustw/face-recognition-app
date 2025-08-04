#!/bin/bash

# Face Recognition App Install Script

set -e

echo "📦 Installing Face Recognition App..."

# Function to check system requirements
check_requirements() {
    echo "🔍 Checking system requirements..."
    
    # Check OS
    OS=$(uname -s)
    echo "✅ OS: $OS"
    
    # Check Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo "✅ Node.js: $NODE_VERSION"
    else
        echo "❌ Node.js not found. Please install Node.js first."
        echo "Download from: https://nodejs.org/"
        exit 1
    fi
    
    # Check npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        echo "✅ npm: $NPM_VERSION"
    else
        echo "❌ npm not found. Please install npm."
        exit 1
    fi
    
    # Check git
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        echo "✅ Git: $GIT_VERSION"
    else
        echo "❌ Git not found. Please install Git."
        exit 1
    fi
    
    # Check available memory
    if command -v free &> /dev/null; then
        MEMORY=$(free -h | grep Mem | awk '{print $2}')
        echo "✅ Memory: $MEMORY"
    fi
    
    # Check available disk space
    if command -v df &> /dev/null; then
        DISK_SPACE=$(df -h . | awk 'NR==2 {print $4}')
        echo "✅ Disk space: $DISK_SPACE available"
    fi
}

# Function to install global dependencies
install_global_deps() {
    echo "📦 Installing global dependencies..."
    
    # Install Vercel CLI
    if ! command -v vercel &> /dev/null; then
        echo "📦 Installing Vercel CLI..."
        npm install -g vercel
    fi
    
    # Install serve for local testing
    if ! command -v serve &> /dev/null; then
        echo "📦 Installing serve..."
        npm install -g serve
    fi
    
    # Install nodemon for development
    if ! command -v nodemon &> /dev/null; then
        echo "📦 Installing nodemon..."
        npm install -g nodemon
    fi
    
    echo "✅ Global dependencies installed"
}

# Function to install project dependencies
install_project_deps() {
    echo "📦 Installing project dependencies..."
    
    # Install dependencies
    npm install
    
    # Install development dependencies
    npm install -D eslint prettier @testing-library/react @testing-library/jest-dom
    
    echo "✅ Project dependencies installed"
}

# Function to setup environment
setup_environment() {
    echo "🔧 Setting up environment..."
    
    # Create necessary directories
    mkdir -p scripts
    mkdir -p backups
    mkdir -p public/models
    mkdir -p .github/workflows
    
    # Make scripts executable
    chmod +x scripts/*.sh
    
    # Create .env.local if it doesn't exist
    if [ ! -f ".env.local" ]; then
        echo "📝 Creating .env.local..."
        cp env.example .env.local
    fi
    
    echo "✅ Environment setup completed"
}

# Function to initialize git
init_git() {
    if [ ! -d ".git" ]; then
        echo "📝 Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit"
        echo "✅ Git repository initialized"
    else
        echo "✅ Git repository already exists"
    fi
}

# Function to run tests
run_tests() {
    echo "🧪 Running tests..."
    npm test -- --coverage --watchAll=false
    echo "✅ Tests passed"
}

# Function to build application
build_app() {
    echo "🏗️ Building application..."
    npm run build
    
    if [ -d "build" ]; then
        echo "✅ Application built successfully"
    else
        echo "❌ Build failed"
        exit 1
    fi
}

# Function to setup development environment
setup_dev_environment() {
    echo "🔧 Setting up development environment..."
    
    # Install development tools
    npm install -D nodemon concurrently
    
    # Create development scripts
    if ! grep -q "dev:server" package.json; then
        echo "📝 Adding development scripts..."
        # This would require modifying package.json
        echo "Note: Add development scripts manually if needed"
    fi
    
    echo "✅ Development environment setup completed"
}

# Function to display installation summary
show_summary() {
    echo ""
    echo "🎉 Installation completed successfully!"
    echo ""
    echo "📋 Installation Summary:"
    echo "- ✅ System requirements checked"
    echo "- ✅ Global dependencies installed"
    echo "- ✅ Project dependencies installed"
    echo "- ✅ Environment configured"
    echo "- ✅ Git repository initialized"
    echo "- ✅ Tests passed"
    echo "- ✅ Application built"
    echo ""
    echo "🚀 Next Steps:"
    echo "1. Run 'npm start' to start development server"
    echo "2. Open http://localhost:3000 in your browser"
    echo "3. Allow camera access when prompted"
    echo "4. Start using the face recognition features!"
    echo ""
    echo "📚 Documentation:"
    echo "- README.md - Main documentation"
    echo "- DEPLOYMENT.md - Deployment guide"
    echo "- CONTRIBUTING.md - Contributing guide"
    echo "- SECURITY.md - Security policy"
    echo ""
    echo "🛠️ Available Commands:"
    echo "- npm start - Start development server"
    echo "- npm run build - Build for production"
    echo "- npm test - Run tests"
    echo "- npm run lint - Run linter"
    echo "- ./scripts/deploy.sh - Deploy to production"
    echo "- ./scripts/backup.sh - Create backup"
    echo "- ./scripts/help.sh - Show help"
    echo ""
    echo "🔧 Scripts:"
    echo "- ./scripts/setup.sh - Initial setup"
    echo "- ./scripts/dev.sh - Start development"
    echo "- ./scripts/test.sh - Run all tests"
    echo "- ./scripts/lint.sh - Run linting"
    echo "- ./scripts/prod.sh - Production build"
    echo "- ./scripts/deploy.sh - Deploy to production"
    echo "- ./scripts/backup.sh - Create backup"
    echo "- ./scripts/monitor.sh - Monitor app"
    echo "- ./scripts/cleanup.sh - Clean up files"
    echo "- ./scripts/update.sh - Update app"
    echo "- ./scripts/help.sh - Show help"
    echo ""
    echo "✨ Happy coding!"
}

# Main installation function
main() {
    echo "🚀 Starting Face Recognition App installation..."
    
    # Check system requirements
    check_requirements
    
    # Install global dependencies
    install_global_deps
    
    # Install project dependencies
    install_project_deps
    
    # Setup environment
    setup_environment
    
    # Initialize git
    init_git
    
    # Setup development environment
    setup_dev_environment
    
    # Run tests
    run_tests
    
    # Build application
    build_app
    
    # Show summary
    show_summary
}

# Handle script interruption
trap 'echo "🛑 Installation interrupted"; exit 1' INT TERM

# Run main function
main 