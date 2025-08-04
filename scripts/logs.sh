#!/bin/bash

# Face Recognition App Logs Script

echo "📋 Face Recognition App - Logs Management"
echo "========================================="
echo ""

# Configuration
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/app.log"
ERROR_LOG="$LOG_DIR/error.log"
ACCESS_LOG="$LOG_DIR/access.log"

# Function to create log directory
create_log_dir() {
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
        echo "📁 Created log directory: $LOG_DIR"
    fi
}

# Function to show log files
show_log_files() {
    echo "📁 Available log files:"
    echo ""
    
    if [ -d "$LOG_DIR" ]; then
        if [ -z "$(ls -A $LOG_DIR)" ]; then
            echo "📝 No log files found"
        else
            ls -la "$LOG_DIR"/
        fi
    else
        echo "📝 Log directory not found"
    fi
}

# Function to view logs
view_logs() {
    local log_type="$1"
    local lines="${2:-50}"
    
    case "$log_type" in
        "app"|"main")
            if [ -f "$LOG_FILE" ]; then
                echo "📋 Application logs (last $lines lines):"
                echo "======================================"
                tail -n "$lines" "$LOG_FILE"
            else
                echo "❌ Application log file not found"
            fi
            ;;
        "error")
            if [ -f "$ERROR_LOG" ]; then
                echo "📋 Error logs (last $lines lines):"
                echo "================================="
                tail -n "$lines" "$ERROR_LOG"
            else
                echo "❌ Error log file not found"
            fi
            ;;
        "access")
            if [ -f "$ACCESS_LOG" ]; then
                echo "📋 Access logs (last $lines lines):"
                echo "=================================="
                tail -n "$lines" "$ACCESS_LOG"
            else
                echo "❌ Access log file not found"
            fi
            ;;
        "all")
            echo "📋 All logs (last $lines lines):"
            echo "================================"
            if [ -f "$LOG_FILE" ]; then
                echo "--- Application Logs ---"
                tail -n "$lines" "$LOG_FILE"
                echo ""
            fi
            if [ -f "$ERROR_LOG" ]; then
                echo "--- Error Logs ---"
                tail -n "$lines" "$ERROR_LOG"
                echo ""
            fi
            if [ -f "$ACCESS_LOG" ]; then
                echo "--- Access Logs ---"
                tail -n "$lines" "$ACCESS_LOG"
            fi
            ;;
        *)
            echo "❌ Unknown log type: $log_type"
            echo "Available types: app, error, access, all"
            ;;
    esac
}

# Function to follow logs
follow_logs() {
    local log_type="$1"
    
    case "$log_type" in
        "app"|"main")
            if [ -f "$LOG_FILE" ]; then
                echo "📋 Following application logs (Ctrl+C to stop):"
                echo "=============================================="
                tail -f "$LOG_FILE"
            else
                echo "❌ Application log file not found"
            fi
            ;;
        "error")
            if [ -f "$ERROR_LOG" ]; then
                echo "📋 Following error logs (Ctrl+C to stop):"
                echo "======================================="
                tail -f "$ERROR_LOG"
            else
                echo "❌ Error log file not found"
            fi
            ;;
        "access")
            if [ -f "$ACCESS_LOG" ]; then
                echo "📋 Following access logs (Ctrl+C to stop):"
                echo "========================================"
                tail -f "$ACCESS_LOG"
            else
                echo "❌ Access log file not found"
            fi
            ;;
        *)
            echo "❌ Unknown log type: $log_type"
            echo "Available types: app, error, access"
            ;;
    esac
}

# Function to search logs
search_logs() {
    local search_term="$1"
    local log_type="$2"
    
    if [ -z "$search_term" ]; then
        echo "❌ Please provide a search term"
        return 1
    fi
    
    case "$log_type" in
        "app"|"main")
            if [ -f "$LOG_FILE" ]; then
                echo "🔍 Searching application logs for: $search_term"
                echo "=============================================="
                grep -i "$search_term" "$LOG_FILE"
            else
                echo "❌ Application log file not found"
            fi
            ;;
        "error")
            if [ -f "$ERROR_LOG" ]; then
                echo "🔍 Searching error logs for: $search_term"
                echo "======================================"
                grep -i "$search_term" "$ERROR_LOG"
            else
                echo "❌ Error log file not found"
            fi
            ;;
        "access")
            if [ -f "$ACCESS_LOG" ]; then
                echo "🔍 Searching access logs for: $search_term"
                echo "======================================="
                grep -i "$search_term" "$ACCESS_LOG"
            else
                echo "❌ Access log file not found"
            fi
            ;;
        "all")
            echo "🔍 Searching all logs for: $search_term"
            echo "====================================="
            if [ -f "$LOG_FILE" ]; then
                echo "--- Application Logs ---"
                grep -i "$search_term" "$LOG_FILE"
                echo ""
            fi
            if [ -f "$ERROR_LOG" ]; then
                echo "--- Error Logs ---"
                grep -i "$search_term" "$ERROR_LOG"
                echo ""
            fi
            if [ -f "$ACCESS_LOG" ]; then
                echo "--- Access Logs ---"
                grep -i "$search_term" "$ACCESS_LOG"
            fi
            ;;
        *)
            echo "❌ Unknown log type: $log_type"
            echo "Available types: app, error, access, all"
            ;;
    esac
}

# Function to clear logs
clear_logs() {
    local log_type="$1"
    
    case "$log_type" in
        "app"|"main")
            if [ -f "$LOG_FILE" ]; then
                > "$LOG_FILE"
                echo "✅ Cleared application logs"
            else
                echo "❌ Application log file not found"
            fi
            ;;
        "error")
            if [ -f "$ERROR_LOG" ]; then
                > "$ERROR_LOG"
                echo "✅ Cleared error logs"
            else
                echo "❌ Error log file not found"
            fi
            ;;
        "access")
            if [ -f "$ACCESS_LOG" ]; then
                > "$ACCESS_LOG"
                echo "✅ Cleared access logs"
            else
                echo "❌ Access log file not found"
            fi
            ;;
        "all")
            if [ -d "$LOG_DIR" ]; then
                find "$LOG_DIR" -name "*.log" -type f -exec truncate -s 0 {} \;
                echo "✅ Cleared all log files"
            else
                echo "❌ Log directory not found"
            fi
            ;;
        *)
            echo "❌ Unknown log type: $log_type"
            echo "Available types: app, error, access, all"
            ;;
    esac
}

# Function to show log statistics
show_stats() {
    echo "📊 Log Statistics:"
    echo "=================="
    
    if [ -d "$LOG_DIR" ]; then
        # Count log files
        LOG_COUNT=$(find "$LOG_DIR" -name "*.log" -type f | wc -l)
        echo "📁 Total log files: $LOG_COUNT"
        
        # Show file sizes
        if [ $LOG_COUNT -gt 0 ]; then
            echo ""
            echo "📏 File sizes:"
            find "$LOG_DIR" -name "*.log" -type f -exec ls -lh {} \;
        fi
        
        # Show line counts
        if [ $LOG_COUNT -gt 0 ]; then
            echo ""
            echo "📝 Line counts:"
            for log_file in "$LOG_DIR"/*.log; do
                if [ -f "$log_file" ]; then
                    line_count=$(wc -l < "$log_file")
                    echo "$(basename "$log_file"): $line_count lines"
                fi
            done
        fi
        
        # Show recent activity
        if [ $LOG_COUNT -gt 0 ]; then
            echo ""
            echo "🕒 Recent activity:"
            find "$LOG_DIR" -name "*.log" -type f -exec ls -lt {} \; | head -5
        fi
    else
        echo "❌ Log directory not found"
    fi
}

# Function to show help
show_help() {
    echo "📋 Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  list                    - Show available log files"
    echo "  view [type] [lines]     - View logs (default: 50 lines)"
    echo "  follow [type]           - Follow logs in real-time"
    echo "  search [term] [type]    - Search logs for term"
    echo "  clear [type]            - Clear logs"
    echo "  stats                   - Show log statistics"
    echo "  help                    - Show this help"
    echo ""
    echo "Log types:"
    echo "  app/main                - Application logs"
    echo "  error                   - Error logs"
    echo "  access                  - Access logs"
    echo "  all                     - All logs"
    echo ""
    echo "Examples:"
    echo "  $0 list"
    echo "  $0 view app 100"
    echo "  $0 follow error"
    echo "  $0 search 'error' all"
    echo "  $0 clear all"
    echo "  $0 stats"
}

# Main function
main() {
    local command="$1"
    local arg1="$2"
    local arg2="$3"
    
    # Create log directory
    create_log_dir
    
    case "$command" in
        "list")
            show_log_files
            ;;
        "view")
            view_logs "$arg1" "$arg2"
            ;;
        "follow")
            follow_logs "$arg1"
            ;;
        "search")
            search_logs "$arg1" "$arg2"
            ;;
        "clear")
            clear_logs "$arg1"
            ;;
        "stats")
            show_stats
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            echo "❌ No command specified"
            show_help
            ;;
        *)
            echo "❌ Unknown command: $command"
            show_help
            ;;
    esac
}

# Run main function
main "$@" 