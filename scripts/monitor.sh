#!/bin/bash

# Face Recognition App Monitoring Script

echo "📊 Starting monitoring..."

# Configuration
APP_URL="http://localhost:3000"
HEALTH_ENDPOINT="$APP_URL/health"
LOG_FILE="monitor.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if app is running
check_app_status() {
    if curl -s "$HEALTH_ENDPOINT" > /dev/null 2>&1; then
        log_message "✅ App is running"
        return 0
    else
        log_message "❌ App is not responding"
        return 1
    fi
}

# Check system resources
check_system_resources() {
    echo "📊 System Resources:"
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
    echo "Memory Usage: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')"
    echo "Disk Usage: $(df -h / | awk 'NR==2 {print $5}')"
    echo ""
}

# Check network connectivity
check_network() {
    if ping -c 1 google.com > /dev/null 2>&1; then
        log_message "✅ Network connectivity OK"
    else
        log_message "❌ Network connectivity issues"
    fi
}

# Check dependencies
check_dependencies() {
    echo "📦 Checking dependencies..."
    
    # Check Node.js
    if command -v node &> /dev/null; then
        echo "✅ Node.js: $(node -v)"
    else
        echo "❌ Node.js not found"
    fi
    
    # Check npm
    if command -v npm &> /dev/null; then
        echo "✅ npm: $(npm -v)"
    else
        echo "❌ npm not found"
    fi
    
    # Check if node_modules exists
    if [ -d "node_modules" ]; then
        echo "✅ Dependencies installed"
    else
        echo "❌ Dependencies not installed"
    fi
    
    echo ""
}

# Main monitoring loop
main() {
    log_message "🚀 Starting monitoring..."
    
    # Initial checks
    check_dependencies
    check_network
    check_system_resources
    
    # Continuous monitoring
    while true; do
        check_app_status
        
        # Wait 30 seconds before next check
        sleep 30
    done
}

# Handle script interruption
trap 'log_message "🛑 Monitoring stopped"; exit 0' INT TERM

# Run main function
main 