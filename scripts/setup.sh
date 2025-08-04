#!/bin/bash

# Face Recognition App Setup Script

set -e

echo "🚀 Setting up Face Recognition App..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js first."
    echo "Download from: https://nodejs.org/"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 16 ]; then
    echo "❌ Node.js version 16 or higher is required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js version: $(node -v)"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install npm."
    exit 1
fi

echo "✅ npm version: $(npm -v)"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p scripts
mkdir -p backups
mkdir -p public/models

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Install development dependencies
echo "🔧 Installing development dependencies..."
npm install -D eslint prettier

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x scripts/*.sh

# Create .env file if it doesn't exist
if [ ! -f ".env.local" ]; then
    echo "📝 Creating .env.local file..."
    cp env.example .env.local
    echo "✅ .env.local created"
fi

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📝 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit"
    echo "✅ Git repository initialized"
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📝 Creating .gitignore..."
    cat > .gitignore << EOF
# Dependencies
node_modules/
/.pnp
.pnp.js

# Production
/build

# Misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Vercel
.vercel
EOF
    echo "✅ .gitignore created"
fi

# Test the setup
echo "🧪 Testing setup..."
npm run build

if [ -d "build" ]; then
    echo "✅ Build test passed!"
else
    echo "❌ Build test failed!"
    exit 1
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Run 'npm start' to start development server"
echo "2. Open http://localhost:3000 in your browser"
echo "3. Allow camera access when prompted"
echo "4. Start using the face recognition features!"
echo ""
echo "📚 Documentation:"
echo "- README.md - Main documentation"
echo "- DEPLOYMENT.md - Deployment guide"
echo "- CONTRIBUTING.md - Contributing guide"
echo ""
echo "🛠️ Available scripts:"
echo "- npm start - Start development server"
echo "- npm run build - Build for production"
echo "- npm test - Run tests"
echo "- npm run lint - Run linter"
echo "- ./scripts/deploy.sh - Deploy to production"
echo "- ./scripts/backup.sh - Create backup"
echo "- ./scripts/cleanup.sh - Clean up files" 