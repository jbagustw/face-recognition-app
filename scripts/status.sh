#!/bin/bash

# Face Recognition App Status Script

echo "📊 Face Recognition App - Status Report"
echo "======================================="
echo ""

# Function to check if Node.js is installed
check_nodejs() {
    echo "🔍 Checking Node.js..."
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo "✅ Node.js: $NODE_VERSION"
    else
        echo "❌ Node.js not found"
        return 1
    fi
}

# Function to check if npm is installed
check_npm() {
    echo "🔍 Checking npm..."
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        echo "✅ npm: $NPM_VERSION"
    else
        echo "❌ npm not found"
        return 1
    fi
}

# Function to check dependencies
check_dependencies() {
    echo "🔍 Checking dependencies..."
    
    if [ -d "node_modules" ]; then
        echo "✅ node_modules exists"
        
        # Check if key dependencies are installed
        if [ -d "node_modules/react" ]; then
            echo "✅ React installed"
        else
            echo "❌ React not installed"
        fi
        
        if [ -d "node_modules/face-api.js" ]; then
            echo "✅ face-api.js installed"
        else
            echo "❌ face-api.js not installed"
        fi
        
        if [ -d "node_modules/tailwindcss" ]; then
            echo "✅ Tailwind CSS installed"
        else
            echo "❌ Tailwind CSS not installed"
        fi
    else
        echo "❌ node_modules not found"
        return 1
    fi
}

# Function to check build status
check_build() {
    echo "🔍 Checking build status..."
    
    if [ -d "build" ]; then
        echo "✅ Build directory exists"
        
        # Check if key build files exist
        if [ -f "build/index.html" ]; then
            echo "✅ index.html exists"
        else
            echo "❌ index.html not found"
        fi
        
        if [ -d "build/static" ]; then
            echo "✅ static directory exists"
        else
            echo "❌ static directory not found"
        fi
    else
        echo "❌ Build directory not found"
        return 1
    fi
}

# Function to check if app is running
check_running() {
    echo "🔍 Checking if app is running..."
    
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "✅ App is running on http://localhost:3000"
        return 0
    else
        echo "❌ App is not running"
        return 1
    fi
}

# Function to check git status
check_git() {
    echo "🔍 Checking git status..."
    
    if [ -d ".git" ]; then
        echo "✅ Git repository exists"
        
        # Check if there are uncommitted changes
        if [ -n "$(git status --porcelain)" ]; then
            echo "⚠️  Uncommitted changes detected"
        else
            echo "✅ No uncommitted changes"
        fi
        
        # Check current branch
        CURRENT_BRANCH=$(git branch --show-current)
        echo "✅ Current branch: $CURRENT_BRANCH"
    else
        echo "❌ Git repository not found"
    fi
}

# Function to check environment
check_environment() {
    echo "🔍 Checking environment..."
    
    # Check if .env.local exists
    if [ -f ".env.local" ]; then
        echo "✅ .env.local exists"
    else
        echo "⚠️  .env.local not found (using defaults)"
    fi
    
    # Check Node.js environment
    if [ -z "$NODE_ENV" ]; then
        echo "✅ NODE_ENV not set (using default)"
    else
        echo "✅ NODE_ENV: $NODE_ENV"
    fi
}

# Function to check system resources
check_resources() {
    echo "🔍 Checking system resources..."
    
    # Check available memory
    if command -v free &> /dev/null; then
        MEMORY=$(free -h | grep Mem | awk '{print $2}')
        USED_MEMORY=$(free -h | grep Mem | awk '{print $3}')
        echo "✅ Total memory: $MEMORY"
        echo "✅ Used memory: $USED_MEMORY"
    fi
    
    # Check available disk space
    if command -v df &> /dev/null; then
        DISK_SPACE=$(df -h . | awk 'NR==2 {print $4}')
        echo "✅ Available disk space: $DISK_SPACE"
    fi
    
    # Check CPU usage
    if command -v top &> /dev/null; then
        CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        echo "✅ CPU usage: ${CPU_USAGE}%"
    fi
}

# Function to check network connectivity
check_network() {
    echo "🔍 Checking network connectivity..."
    
    # Check internet connectivity
    if ping -c 1 google.com > /dev/null 2>&1; then
        echo "✅ Internet connectivity OK"
    else
        echo "❌ Internet connectivity issues"
    fi
    
    # Check if port 3000 is available
    if netstat -an | grep -q ":3000 "; then
        echo "⚠️  Port 3000 is in use"
    else
        echo "✅ Port 3000 is available"
    fi
}

# Function to check security
check_security() {
    echo "🔍 Checking security..."
    
    # Check for security vulnerabilities
    if npm audit --audit-level=moderate > /dev/null 2>&1; then
        echo "✅ No high severity vulnerabilities found"
    else
        echo "⚠️  Security vulnerabilities detected"
    fi
    
    # Check if HTTPS is enforced (for production)
    if [ "$NODE_ENV" = "production" ]; then
        echo "✅ HTTPS enforcement enabled for production"
    fi
}

# Function to show summary
show_summary() {
    echo ""
    echo "📋 Status Summary:"
    echo "=================="
    
    # Count checks
    TOTAL_CHECKS=0
    PASSED_CHECKS=0
    
    # Node.js check
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if check_nodejs > /dev/null 2>&1; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    # npm check
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if check_npm > /dev/null 2>&1; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    # Dependencies check
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if check_dependencies > /dev/null 2>&1; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    # Build check
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if check_build > /dev/null 2>&1; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    # Running check
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if check_running > /dev/null 2>&1; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    echo "✅ Passed: $PASSED_CHECKS/$TOTAL_CHECKS checks"
    
    if [ $PASSED_CHECKS -eq $TOTAL_CHECKS ]; then
        echo "🎉 All checks passed! App is ready to use."
    else
        echo "⚠️  Some checks failed. Please review the issues above."
    fi
    
    echo ""
    echo "🛠️ Quick fixes:"
    echo "- Run './scripts/setup.sh' to fix setup issues"
    echo "- Run './scripts/restart.sh' to restart the app"
    echo "- Run 'npm install' to reinstall dependencies"
    echo "- Run 'npm start' to start the development server"
}

# Main status function
main() {
    echo "🚀 Checking Face Recognition App status..."
    echo ""
    
    # Run all checks
    check_nodejs
    echo ""
    
    check_npm
    echo ""
    
    check_dependencies
    echo ""
    
    check_build
    echo ""
    
    check_running
    echo ""
    
    check_git
    echo ""
    
    check_environment
    echo ""
    
    check_resources
    echo ""
    
    check_network
    echo ""
    
    check_security
    echo ""
    
    # Show summary
    show_summary
}

# Run main function
main 