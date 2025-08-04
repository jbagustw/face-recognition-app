#!/bin/bash

# Face Recognition App Info Script

echo "📋 Face Recognition App - Information Center"
echo "==========================================="
echo ""

# Function to show basic info
show_basic_info() {
    echo "📱 Basic Information:"
    echo "===================="
    
    # Get app name and version
    if [ -f "package.json" ]; then
        NAME=$(node -p "require('./package.json').name")
        VERSION=$(node -p "require('./package.json').version")
        DESCRIPTION=$(node -p "require('./package.json').description || 'Face Recognition Attendance System'")
        
        echo "Name: $NAME"
        echo "Version: $VERSION"
        echo "Description: $DESCRIPTION"
    else
        echo "❌ package.json not found"
    fi
    
    # Check if app is running
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "Status: ✅ Running"
        echo "URL: http://localhost:3000"
    else
        echo "Status: ❌ Not running"
    fi
    
    echo ""
}

# Function to show system info
show_system_info() {
    echo "💻 System Information:"
    echo "====================="
    
    # OS
    OS=$(uname -s)
    echo "Operating System: $OS"
    
    # Architecture
    ARCH=$(uname -m)
    echo "Architecture: $ARCH"
    
    # Kernel version
    KERNEL=$(uname -r)
    echo "Kernel: $KERNEL"
    
    # Hostname
    HOSTNAME=$(hostname)
    echo "Hostname: $HOSTNAME"
    
    # CPU info
    if command -v lscpu &> /dev/null; then
        CPU_MODEL=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)
        echo "CPU: $CPU_MODEL"
    fi
    
    # Memory info
    if command -v free &> /dev/null; then
        TOTAL_MEM=$(free -h | grep Mem | awk '{print $2}')
        USED_MEM=$(free -h | grep Mem | awk '{print $3}')
        echo "Memory: $USED_MEM / $TOTAL_MEM"
    fi
    
    # Disk info
    if command -v df &> /dev/null; then
        DISK_USAGE=$(df -h . | awk 'NR==2 {print $5}')
        DISK_AVAILABLE=$(df -h . | awk 'NR==2 {print $4}')
        echo "Disk: $DISK_USAGE used, $DISK_AVAILABLE available"
    fi
    
    echo ""
}

# Function to show development tools info
show_dev_tools_info() {
    echo "🔧 Development Tools:"
    echo "===================="
    
    # Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo "Node.js: $NODE_VERSION"
    else
        echo "Node.js: ❌ Not installed"
    fi
    
    # npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        echo "npm: $NPM_VERSION"
    else
        echo "npm: ❌ Not installed"
    fi
    
    # Git
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        echo "Git: $GIT_VERSION"
    else
        echo "Git: ❌ Not installed"
    fi
    
    # Docker
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        echo "Docker: $DOCKER_VERSION"
    else
        echo "Docker: ❌ Not installed"
    fi
    
    # Vercel CLI
    if command -v vercel &> /dev/null; then
        echo "Vercel CLI: ✅ Installed"
    else
        echo "Vercel CLI: ❌ Not installed"
    fi
    
    echo ""
}

# Function to show project structure
show_project_structure() {
    echo "📁 Project Structure:"
    echo "===================="
    
    # Count files and directories
    TOTAL_FILES=$(find . -type f | wc -l)
    TOTAL_DIRS=$(find . -type d | wc -l)
    
    echo "Total files: $TOTAL_FILES"
    echo "Total directories: $TOTAL_DIRS"
    
    # Show key directories
    echo ""
    echo "Key directories:"
    if [ -d "src" ]; then
        SRC_FILES=$(find src -type f | wc -l)
        echo "  src/ ($SRC_FILES files)"
    fi
    
    if [ -d "public" ]; then
        PUBLIC_FILES=$(find public -type f | wc -l)
        echo "  public/ ($PUBLIC_FILES files)"
    fi
    
    if [ -d "scripts" ]; then
        SCRIPTS_FILES=$(find scripts -type f | wc -l)
        echo "  scripts/ ($SCRIPTS_FILES files)"
    fi
    
    if [ -d "build" ]; then
        BUILD_FILES=$(find build -type f | wc -l)
        echo "  build/ ($BUILD_FILES files)"
    fi
    
    if [ -d "node_modules" ]; then
        echo "  node_modules/ (installed)"
    fi
    
    echo ""
}

# Function to show dependencies info
show_dependencies_info() {
    echo "📦 Dependencies Information:"
    echo "==========================="
    
    if [ -f "package.json" ]; then
        # Count dependencies
        DEP_COUNT=$(node -p "Object.keys(require('./package.json').dependencies || {}).length")
        DEV_DEP_COUNT=$(node -p "Object.keys(require('./package.json').devDependencies || {}).length")
        
        echo "Production dependencies: $DEP_COUNT"
        echo "Development dependencies: $DEV_DEP_COUNT"
        
        # Show key dependencies
        echo ""
        echo "Key dependencies:"
        if [ -d "node_modules/react" ]; then
            echo "  ✅ React"
        else
            echo "  ❌ React"
        fi
        
        if [ -d "node_modules/face-api.js" ]; then
            echo "  ✅ face-api.js"
        else
            echo "  ❌ face-api.js"
        fi
        
        if [ -d "node_modules/tailwindcss" ]; then
            echo "  ✅ Tailwind CSS"
        else
            echo "  ❌ Tailwind CSS"
        fi
        
        if [ -d "node_modules/lucide-react" ]; then
            echo "  ✅ Lucide React"
        else
            echo "  ❌ Lucide React"
        fi
    else
        echo "❌ package.json not found"
    fi
    
    echo ""
}

# Function to show build info
show_build_info() {
    echo "🏗️ Build Information:"
    echo "===================="
    
    if [ -d "build" ]; then
        echo "Status: ✅ Built"
        
        # Build size
        BUILD_SIZE=$(du -sh build 2>/dev/null | cut -f1)
        echo "Size: $BUILD_SIZE"
        
        # Build date
        BUILD_DATE=$(stat -c %y build 2>/dev/null || echo "unknown")
        echo "Date: $BUILD_DATE"
        
        # Check key files
        echo ""
        echo "Key files:"
        if [ -f "build/index.html" ]; then
            echo "  ✅ index.html"
        else
            echo "  ❌ index.html"
        fi
        
        if [ -d "build/static" ]; then
            STATIC_FILES=$(find build/static -type f | wc -l)
            echo "  ✅ static/ ($STATIC_FILES files)"
        else
            echo "  ❌ static/"
        fi
    else
        echo "Status: ❌ Not built"
        echo "Run 'npm run build' to build the application"
    fi
    
    echo ""
}

# Function to show git info
show_git_info() {
    echo "📝 Git Information:"
    echo "=================="
    
    if [ -d ".git" ]; then
        # Current branch
        CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
        echo "Branch: $CURRENT_BRANCH"
        
        # Last commit
        LAST_COMMIT=$(git log -1 --format="%H" 2>/dev/null || echo "unknown")
        echo "Last commit: $LAST_COMMIT"
        
        # Last commit message
        LAST_COMMIT_MSG=$(git log -1 --format="%s" 2>/dev/null || echo "unknown")
        echo "Last commit message: $LAST_COMMIT_MSG"
        
        # Commit count
        COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        echo "Total commits: $COMMIT_COUNT"
        
        # Remote URL
        REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "none")
        echo "Remote URL: $REMOTE_URL"
        
        # Uncommitted changes
        if [ -n "$(git status --porcelain)" ]; then
            echo "Status: ⚠️  Uncommitted changes"
        else
            echo "Status: ✅ Clean working directory"
        fi
    else
        echo "Status: ❌ Not a git repository"
    fi
    
    echo ""
}

# Function to show environment info
show_environment_info() {
    echo "🌍 Environment Information:"
    echo "=========================="
    
    # NODE_ENV
    if [ -z "$NODE_ENV" ]; then
        echo "NODE_ENV: development (default)"
    else
        echo "NODE_ENV: $NODE_ENV"
    fi
    
    # Current directory
    CURRENT_DIR=$(pwd)
    echo "Current directory: $CURRENT_DIR"
    
    # User
    USER=$(whoami)
    echo "User: $USER"
    
    # Home directory
    HOME_DIR=$HOME
    echo "Home directory: $HOME_DIR"
    
    # Shell
    SHELL_NAME=$SHELL
    echo "Shell: $SHELL_NAME"
    
    # Path
    PATH_COUNT=$(echo $PATH | tr ':' '\n' | wc -l)
    echo "PATH entries: $PATH_COUNT"
    
    echo ""
}

# Function to show network info
show_network_info() {
    echo "🌐 Network Information:"
    echo "======================"
    
    # Internet connectivity
    if ping -c 1 google.com > /dev/null 2>&1; then
        echo "Internet: ✅ Connected"
    else
        echo "Internet: ❌ Not connected"
    fi
    
    # Local IP
    if command -v ip &> /dev/null; then
        LOCAL_IP=$(ip route get 1.1.1.1 | awk '{print $7}' | head -1)
        echo "Local IP: $LOCAL_IP"
    fi
    
    # Port 3000 status
    if netstat -an | grep -q ":3000 "; then
        echo "Port 3000: ⚠️  In use"
    else
        echo "Port 3000: ✅ Available"
    fi
    
    # DNS
    if command -v nslookup &> /dev/null; then
        DNS_SERVER=$(nslookup google.com | grep "Server:" | awk '{print $2}' | head -1)
        echo "DNS Server: $DNS_SERVER"
    fi
    
    echo ""
}

# Function to show security info
show_security_info() {
    echo "🔒 Security Information:"
    echo "======================="
    
    # Check for security vulnerabilities
    if [ -f "package.json" ]; then
        if npm audit --audit-level=moderate > /dev/null 2>&1; then
            echo "npm audit: ✅ No high severity vulnerabilities"
        else
            echo "npm audit: ⚠️  Vulnerabilities detected"
        fi
    fi
    
    # Check if running as root
    if [ "$(id -u)" -eq 0 ]; then
        echo "User: ⚠️  Running as root"
    else
        echo "User: ✅ Running as non-root user"
    fi
    
    # Check file permissions
    if [ -f "package.json" ]; then
        PERMS=$(stat -c %a package.json)
        echo "package.json permissions: $PERMS"
    fi
    
    # Check for sensitive files
    SENSITIVE_FILES=(".env" ".env.local" ".env.production")
    for file in "${SENSITIVE_FILES[@]}"; do
        if [ -f "$file" ]; then
            echo "⚠️  $file exists"
        fi
    done
    
    echo ""
}

# Function to show performance info
show_performance_info() {
    echo "⚡ Performance Information:"
    echo "=========================="
    
    # CPU usage
    if command -v top &> /dev/null; then
        CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        echo "CPU usage: ${CPU_USAGE}%"
    fi
    
    # Memory usage
    if command -v free &> /dev/null; then
        MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')
        echo "Memory usage: $MEMORY_USAGE"
    fi
    
    # Disk usage
    if command -v df &> /dev/null; then
        DISK_USAGE=$(df -h . | awk 'NR==2 {print $5}')
        echo "Disk usage: $DISK_USAGE"
    fi
    
    # Load average
    if command -v uptime &> /dev/null; then
        LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
        echo "Load average: $LOAD_AVG"
    fi
    
    echo ""
}

# Function to show summary
show_summary() {
    echo "📊 Summary:"
    echo "==========="
    
    # Count checks
    TOTAL_CHECKS=0
    PASSED_CHECKS=0
    
    # Basic checks
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [ -f "package.json" ]; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [ -d "node_modules" ]; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [ -d "build" ]; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if command -v node &> /dev/null; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
    
    echo "✅ Passed: $PASSED_CHECKS/$TOTAL_CHECKS checks"
    
    if [ $PASSED_CHECKS -eq $TOTAL_CHECKS ]; then
        echo "🎉 All checks passed! App is ready to use."
    else
        echo "⚠️  Some checks failed. Please review the issues above."
    fi
    
    echo ""
    echo "🛠️ Quick actions:"
    echo "- Run './scripts/setup.sh' to fix setup issues"
    echo "- Run 'npm start' to start the app"
    echo "- Run 'npm run build' to build for production"
    echo "- Run './scripts/help.sh' for more commands"
}

# Main function
main() {
    echo "🚀 Gathering Face Recognition App information..."
    echo ""
    
    show_basic_info
    show_system_info
    show_dev_tools_info
    show_project_structure
    show_dependencies_info
    show_build_info
    show_git_info
    show_environment_info
    show_network_info
    show_security_info
    show_performance_info
    show_summary
}

# Run main function
main 