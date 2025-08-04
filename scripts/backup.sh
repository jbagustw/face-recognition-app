#!/bin/bash

# Face Recognition App Backup Script

set -e

# Configuration
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="face_recognition_backup_$DATE"

echo "💾 Starting backup process..."

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Create backup archive
echo "📦 Creating backup archive..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" \
    --exclude=node_modules \
    --exclude=build \
    --exclude=.git \
    --exclude=backups \
    --exclude=*.log \
    .

# Check if backup was successful
if [ -f "$BACKUP_DIR/$BACKUP_NAME.tar.gz" ]; then
    echo "✅ Backup created successfully: $BACKUP_NAME.tar.gz"
    
    # Get backup size
    BACKUP_SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME.tar.gz" | cut -f1)
    echo "📊 Backup size: $BACKUP_SIZE"
    
    # List recent backups
    echo "📋 Recent backups:"
    ls -la "$BACKUP_DIR"/*.tar.gz | tail -5
else
    echo "❌ Backup failed!"
    exit 1
fi

# Optional: Clean old backups (keep last 10)
echo "🧹 Cleaning old backups..."
cd "$BACKUP_DIR"
ls -t *.tar.gz | tail -n +11 | xargs -r rm

echo "🎉 Backup process completed!" 