#!/bin/bash

# Face Recognition App Linting Script

set -e

echo "🔍 Starting linting process..."

# Check if ESLint is available
if ! command -v npx &> /dev/null; then
    echo "❌ npx not found. Please install Node.js and npm."
    exit 1
fi

# Run ESLint
echo "🔍 Running ESLint..."
npx eslint src/ --ext .js,.jsx --fix

# Run Prettier
echo "💅 Running Prettier..."
npx prettier --write "src/**/*.{js,jsx,css,md}"

# Check for TypeScript (if available)
if [ -f "tsconfig.json" ]; then
    echo "🔍 Running TypeScript check..."
    npx tsc --noEmit
fi

# Check for unused dependencies
echo "📦 Checking for unused dependencies..."
npx depcheck

# Check for security vulnerabilities
echo "🔒 Checking for security vulnerabilities..."
npm audit --audit-level=moderate

echo "✅ Linting completed successfully!" 