#!/bin/bash

# Face Recognition App Deployment Script
# Usage: ./scripts/deploy.sh [vercel|docker|github-pages]

set -e

echo "🚀 Starting deployment..."

# Check if environment is set
if [ -z "$NODE_ENV" ]; then
    export NODE_ENV=production
fi

# Build the application
echo "📦 Building application..."
npm run build

# Check if build was successful
if [ ! -d "build" ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build completed successfully!"

# Deploy based on argument
case "${1:-vercel}" in
    "vercel")
        echo "🌐 Deploying to Vercel..."
        if command -v vercel &> /dev/null; then
            vercel --prod
        else
            echo "❌ Vercel CLI not found. Please install with: npm i -g vercel"
            exit 1
        fi
        ;;
    "docker")
        echo "🐳 Deploying with Docker..."
        if command -v docker &> /dev/null; then
            docker build -t face-recognition-app .
            docker run -p 3000:80 face-recognition-app
        else
            echo "❌ Docker not found. Please install Docker first."
            exit 1
        fi
        ;;
    "github-pages")
        echo "📚 Deploying to GitHub Pages..."
        if [ -z "$GITHUB_TOKEN" ]; then
            echo "❌ GITHUB_TOKEN not set. Please set your GitHub token."
            exit 1
        fi
        npm run deploy
        ;;
    *)
        echo "❌ Unknown deployment target: $1"
        echo "Available options: vercel, docker, github-pages"
        exit 1
        ;;
esac

echo "🎉 Deployment completed successfully!" 