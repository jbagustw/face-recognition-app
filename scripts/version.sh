#!/bin/bash

# Face Recognition App Version Script

echo "📋 Face Recognition App - Version Information"
echo "============================================"
echo ""

# Get version from package.json
get_version() {
    if [ -f "package.json" ]; then
        VERSION=$(node -p "require('./package.json').version")
        echo "$VERSION"
    else
        echo "unknown"
    fi
}

# Get name from package.json
get_name() {
    if [ -f "package.json" ]; then
        NAME=$(node -p "require('./package.json').name")
        echo "$NAME"
    else
        echo "face-recognition-app"
    fi
}

# Get description from package.json
get_description() {
    if [ -f "package.json" ]; then
        DESCRIPTION=$(node -p "require('./package.json').description || 'Face Recognition Attendance System'")
        echo "$DESCRIPTION"
    else
        echo "Face Recognition Attendance System"
    fi
}

# Get dependencies
get_dependencies() {
    if [ -f "package.json" ]; then
        echo "📦 Dependencies:"
        echo "==============="
        node -p "Object.keys(require('./package.json').dependencies || {}).join('\n')" | sort
    fi
}

# Get dev dependencies
get_dev_dependencies() {
    if [ -f "package.json" ]; then
        echo ""
        echo "🔧 Development Dependencies:"
        echo "============================"
        node -p "Object.keys(require('./package.json').devDependencies || {}).join('\n')" | sort
    fi
}

# Get scripts
get_scripts() {
    if [ -f "package.json" ]; then
        echo ""
        echo "📜 Available Scripts:"
        echo "====================="
        node -p "Object.keys(require('./package.json').scripts || {}).join('\n')" | sort
    fi
}

# Get git information
get_git_info() {
    if [ -d ".git" ]; then
        echo ""
        echo "📝 Git Information:"
        echo "=================="
        
        # Get current branch
        CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
        echo "Branch: $CURRENT_BRANCH"
        
        # Get last commit
        LAST_COMMIT=$(git log -1 --format="%H" 2>/dev/null || echo "unknown")
        echo "Last commit: $LAST_COMMIT"
        
        # Get last commit date
        LAST_COMMIT_DATE=$(git log -1 --format="%cd" 2>/dev/null || echo "unknown")
        echo "Last commit date: $LAST_COMMIT_DATE"
        
        # Get commit count
        COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        echo "Total commits: $COMMIT_COUNT"
        
        # Get remote URL
        REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "none")
        echo "Remote URL: $REMOTE_URL"
    fi
}

# Get build information
get_build_info() {
    echo ""
    echo "🏗️ Build Information:"
    echo "===================="
    
    # Check if build exists
    if [ -d "build" ]; then
        echo "Build status: ✅ Built"
        
        # Get build size
        BUILD_SIZE=$(du -sh build 2>/dev/null | cut -f1)
        echo "Build size: $BUILD_SIZE"
        
        # Get build date
        BUILD_DATE=$(stat -c %y build 2>/dev/null || echo "unknown")
        echo "Build date: $BUILD_DATE"
        
        # Check key build files
        if [ -f "build/index.html" ]; then
            echo "index.html: ✅ Present"
        else
            echo "index.html: ❌ Missing"
        fi
        
        if [ -d "build/static" ]; then
            echo "static files: ✅ Present"
        else
            echo "static files: ❌ Missing"
        fi
    else
        echo "Build status: ❌ Not built"
    fi
}

# Get environment information
get_env_info() {
    echo ""
    echo "🌍 Environment Information:"
    echo "=========================="
    
    # Node.js version
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo "Node.js: $NODE_VERSION"
    else
        echo "Node.js: ❌ Not installed"
    fi
    
    # npm version
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        echo "npm: $NPM_VERSION"
    else
        echo "npm: ❌ Not installed"
    fi
    
    # Git version
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        echo "Git: $GIT_VERSION"
    else
        echo "Git: ❌ Not installed"
    fi
    
    # Operating system
    OS=$(uname -s)
    echo "OS: $OS"
    
    # Architecture
    ARCH=$(uname -m)
    echo "Architecture: $ARCH"
    
    # Environment
    if [ -z "$NODE_ENV" ]; then
        echo "NODE_ENV: development (default)"
    else
        echo "NODE_ENV: $NODE_ENV"
    fi
}

# Get application information
get_app_info() {
    echo ""
    echo "📱 Application Information:"
    echo "=========================="
    
    NAME=$(get_name)
    VERSION=$(get_version)
    DESCRIPTION=$(get_description)
    
    echo "Name: $NAME"
    echo "Version: $VERSION"
    echo "Description: $DESCRIPTION"
    
    # Check if app is running
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "Status: ✅ Running"
        echo "URL: http://localhost:3000"
    else
        echo "Status: ❌ Not running"
    fi
}

# Get changelog information
get_changelog_info() {
    if [ -f "CHANGELOG.md" ]; then
        echo ""
        echo "📋 Recent Changes:"
        echo "=================="
        
        # Get the latest version section
        LATEST_VERSION=$(grep -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" CHANGELOG.md | head -1)
        if [ -n "$LATEST_VERSION" ]; then
            echo "Latest version: $LATEST_VERSION"
            
            # Get the content of the latest version
            sed -n "/$LATEST_VERSION/,/^## /p" CHANGELOG.md | head -20
        fi
    fi
}

# Get license information
get_license_info() {
    if [ -f "LICENSE" ]; then
        echo ""
        echo "📄 License Information:"
        echo "======================"
        
        # Get first line of license
        LICENSE_TYPE=$(head -1 LICENSE)
        echo "License: $LICENSE_TYPE"
        
        # Get copyright year
        COPYRIGHT_YEAR=$(grep -o "Copyright (c) [0-9]*" LICENSE | head -1)
        if [ -n "$COPYRIGHT_YEAR" ]; then
            echo "$COPYRIGHT_YEAR"
        fi
    fi
}

# Show full version information
show_full_info() {
    get_app_info
    get_env_info
    get_build_info
    get_git_info
    get_dependencies
    get_dev_dependencies
    get_scripts
    get_changelog_info
    get_license_info
}

# Show short version information
show_short_info() {
    NAME=$(get_name)
    VERSION=$(get_version)
    DESCRIPTION=$(get_description)
    
    echo "📱 $NAME v$VERSION"
    echo "📝 $DESCRIPTION"
    
    # Check if app is running
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "✅ Running at http://localhost:3000"
    else
        echo "❌ Not running"
    fi
}

# Show help
show_help() {
    echo "📋 Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  -v, --version           - Show version only"
    echo "  -s, --short             - Show short information"
    echo "  -f, --full              - Show full information (default)"
    echo "  -h, --help              - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                      - Show full information"
    echo "  $0 --version            - Show version only"
    echo "  $0 --short              - Show short information"
    echo "  $0 --full               - Show full information"
}

# Main function
main() {
    local option="$1"
    
    case "$option" in
        "-v"|"--version")
            get_version
            ;;
        "-s"|"--short")
            show_short_info
            ;;
        "-f"|"--full"|"")
            show_full_info
            ;;
        "-h"|"--help")
            show_help
            ;;
        *)
            echo "❌ Unknown option: $option"
            show_help
            ;;
    esac
}

# Run main function
main "$@" 