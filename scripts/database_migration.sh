#!/bin/bash

# Database Migration Script for Fly.io Migration
# This script handles backup and restoration of databases during migration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./db_backups"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Function to print colored output
print_status() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

print_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

# Function to backup database from server
backup_database() {
    local env=$1
    local host=$2
    local user=$3
    local db_name=$4
    local backup_file="${BACKUP_DIR}/${env}_${db_name}_${TIMESTAMP}.sql"
    
    print_status "Starting backup for $env environment..."
    
    # SSH to server and create database dump
    ssh ${user}@${host} "mysqldump --single-transaction --routines --triggers ${db_name}" > ${backup_file}
    
    if [ $? -eq 0 ]; then
        print_status "Backup completed: ${backup_file}"
        # Compress the backup
        gzip ${backup_file}
        print_status "Backup compressed: ${backup_file}.gz"
    else
        print_error "Backup failed for $env environment"
        exit 1
    fi
}

# Function to restore database to Fly.io PostgreSQL
restore_to_fly() {
    local env=$1
    local backup_file=$2
    local fly_app=$3
    
    print_status "Restoring database to Fly.io $env environment..."
    
    # Decompress if needed
    if [[ $backup_file == *.gz ]]; then
        print_status "Decompressing backup..."
        gunzip -k $backup_file
        backup_file=${backup_file%.gz}
    fi
    
    # Convert MySQL dump to PostgreSQL format
    print_status "Converting MySQL dump to PostgreSQL format..."
    local pg_file="${backup_file%.sql}_pg.sql"
    
    # Basic conversion (you may need to adjust based on your schema)
    sed -e 's/`/"/g' \
        -e 's/\\"/"/g' \
        -e 's/UNSIGNED//g' \
        -e 's/AUTO_INCREMENT/SERIAL/g' \
        -e 's/TINYINT(1)/BOOLEAN/g' \
        -e 's/DATETIME/TIMESTAMP/g' \
        -e 's/ENGINE=InnoDB.*;//g' \
        $backup_file > $pg_file
    
    # Get database URL from Fly.io
    print_status "Getting database connection from Fly.io..."
    local db_url=$(fly postgres db-url --app ${fly_app}-db)
    
    # Restore to PostgreSQL
    print_status "Restoring to PostgreSQL..."
    psql $db_url < $pg_file
    
    if [ $? -eq 0 ]; then
        print_status "Database restored successfully to $env"
    else
        print_error "Database restoration failed for $env"
        exit 1
    fi
}

# Function to backup Active Storage files
backup_storage() {
    local env=$1
    local host=$2
    local user=$3
    local storage_path=$4
    local backup_file="${BACKUP_DIR}/${env}_storage_${TIMESTAMP}.tar.gz"
    
    print_status "Backing up Active Storage files for $env..."
    
    ssh ${user}@${host} "cd ${storage_path} && tar czf - storage/" > ${backup_file}
    
    if [ $? -eq 0 ]; then
        print_status "Storage backup completed: ${backup_file}"
    else
        print_error "Storage backup failed for $env"
    fi
}

# Main menu
show_menu() {
    echo "==================================="
    echo "Database Migration Tool for Fly.io"
    echo "==================================="
    echo "1) Backup Development Database"
    echo "2) Backup Staging Database"
    echo "3) Restore to Fly.io Development"
    echo "4) Restore to Fly.io Staging"
    echo "5) Backup Active Storage (Development)"
    echo "6) Backup Active Storage (Staging)"
    echo "7) Full Migration (Dev)"
    echo "8) Full Migration (Staging)"
    echo "9) Exit"
}

# Main script
while true; do
    show_menu
    read -p "Select an option: " choice
    
    case $choice in
        1)
            print_status "Backing up Development database..."
            backup_database "development" "18.176.164.49" "deploy" "line_insight_development"
            ;;
        2)
            print_status "Backing up Staging database..."
            backup_database "staging" "104.198.81.172" "dotops" "line_insight_staging"
            ;;
        3)
            read -p "Enter backup file path: " backup_file
            restore_to_fly "development" "$backup_file" "hatamotohq-dev"
            ;;
        4)
            read -p "Enter backup file path: " backup_file
            restore_to_fly "staging" "$backup_file" "hatamotohq-staging"
            ;;
        5)
            backup_storage "development" "18.176.164.49" "deploy" "/home/deploy/apps/line-insight/shared"
            ;;
        6)
            backup_storage "staging" "104.198.81.172" "dotops" "/home/dotops/apps/line-insight/shared"
            ;;
        7)
            print_status "Starting full migration for Development..."
            backup_database "development" "18.176.164.49" "deploy" "line_insight_development"
            backup_storage "development" "18.176.164.49" "deploy" "/home/deploy/apps/line-insight/shared"
            # Latest backup file
            latest_backup=$(ls -t ${BACKUP_DIR}/development_line_insight_development_*.sql.gz | head -1)
            restore_to_fly "development" "$latest_backup" "hatamotohq-dev"
            ;;
        8)
            print_status "Starting full migration for Staging..."
            backup_database "staging" "104.198.81.172" "dotops" "line_insight_staging"
            backup_storage "staging" "104.198.81.172" "dotops" "/home/dotops/apps/line-insight/shared"
            # Latest backup file
            latest_backup=$(ls -t ${BACKUP_DIR}/staging_line_insight_staging_*.sql.gz | head -1)
            restore_to_fly "staging" "$latest_backup" "hatamotohq-staging"
            ;;
        9)
            print_status "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
    
    echo
    read -p "Press Enter to continue..."
    clear
done