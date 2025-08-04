#!/bin/bash

# Face Recognition App Testing Script

set -e

echo "🧪 Starting tests..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Run linter
echo "🔍 Running linter..."
npm run lint

# Run tests
echo "🧪 Running tests..."
npm test -- --coverage --watchAll=false

# Run security audit
echo "🔒 Running security audit..."
npm audit --audit-level=moderate

# Build test
echo "🏗️ Testing build..."
npm run build

# Check build output
if [ -d "build" ]; then
    echo "✅ Build test passed!"
else
    echo "❌ Build test failed!"
    exit 1
fi

echo "🎉 All tests passed successfully!" 