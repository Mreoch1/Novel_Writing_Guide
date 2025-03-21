#!/bin/bash

# Google Docs Sync Script for "Doing Nothing, Badly" - macOS version
# This script helps automate the process of syncing local markdown files to Google Docs

# Configuration
LOCAL_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# macOS Google Drive path (updated for your specific Mac)
GDRIVE_SYNC_DIR="$HOME/Library/CloudStorage/GoogleDrive-Mreoch82@hotmail.com/My Drive/Doing Nothing, Badly"
LOG_FILE="$LOCAL_PROJECT_DIR/logs/gdocs_sync.log"

# Create logs directory if it doesn't exist
mkdir -p "$LOCAL_PROJECT_DIR/logs"

# Function to log messages
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to check if Google Drive is accessible
check_gdrive() {
  if [ ! -d "$GDRIVE_SYNC_DIR" ]; then
    log_message "ERROR: Google Drive directory not found at $GDRIVE_SYNC_DIR"
    log_message "Please check that Google Drive is installed and running on your Mac."
    log_message "You may need to adjust GDRIVE_SYNC_DIR in this script to match your setup."
    log_message "Common macOS paths for Google Drive:"
    log_message "  - $HOME/Library/CloudStorage/GoogleDrive-*/"
    log_message "  - $HOME/Google Drive/"
    log_message "  - $HOME/Google Drive/My Drive/"
    exit 1
  else
    log_message "Google Drive directory found at $GDRIVE_SYNC_DIR"
  fi
}

# Function to ensure Google Drive folder structure matches local structure
create_folder_structure() {
  log_message "Creating folder structure in Google Drive..."
  
  # Create main folders if they don't exist
  for dir in "chapters" "characters" "settings" "docs"; do
    if [ ! -d "$GDRIVE_SYNC_DIR/$dir" ]; then
      mkdir -p "$GDRIVE_SYNC_DIR/$dir"
      log_message "Created directory: $dir"
    fi
  done
  
  # Create characters subfolders
  for subdir in "locals" "reality_show"; do
    if [ ! -d "$GDRIVE_SYNC_DIR/characters/$subdir" ]; then
      mkdir -p "$GDRIVE_SYNC_DIR/characters/$subdir"
      log_message "Created directory: characters/$subdir"
    fi
  done
}

# Function to sync markdown files to Google Drive
sync_markdown_files() {
  log_message "Syncing markdown files to Google Drive..."
  
  # Find all markdown files in the project
  find "$LOCAL_PROJECT_DIR/src" -name "*.md" -type f | while read -r file; do
    # Get relative path
    # Use perl instead of realpath which might not be available on macOS by default
    rel_path=$(perl -e 'use File::Spec; print File::Spec->abs2rel($ARGV[0], $ARGV[1])' "$file" "$LOCAL_PROJECT_DIR/src")
    dir_path=$(dirname "$rel_path")
    file_name=$(basename "$file")
    
    # Create target directory if it doesn't exist
    target_dir="$GDRIVE_SYNC_DIR/$dir_path"
    mkdir -p "$target_dir"
    
    # Copy the file to Google Drive
    cp "$file" "$target_dir/$file_name"
    log_message "Synced: $rel_path"
  done
}

# Function to sync back from Google Drive to local
sync_from_gdrive() {
  log_message "Checking for modified files in Google Drive..."
  
  find "$GDRIVE_SYNC_DIR" -name "*.md" -type f | while read -r gdrive_file; do
    # Get relative path
    # Use perl instead of realpath which might not be available on macOS by default
    rel_path=$(perl -e 'use File::Spec; print File::Spec->abs2rel($ARGV[0], $ARGV[1])' "$gdrive_file" "$GDRIVE_SYNC_DIR")
    local_file="$LOCAL_PROJECT_DIR/src/$rel_path"
    
    # Check if local file exists
    if [ -f "$local_file" ]; then
      # Compare modification times (macOS uses -f %m for stat, not -c %Y)
      gdrive_mod_time=$(stat -f %m "$gdrive_file")
      local_mod_time=$(stat -f %m "$local_file")
      
      if [ "$gdrive_mod_time" -gt "$local_mod_time" ]; then
        # Google Drive version is newer
        cp "$gdrive_file" "$local_file"
        log_message "Updated local file from Google Drive: $rel_path"
      fi
    else
      # Local file doesn't exist, copy it
      dir_path=$(dirname "$local_file")
      mkdir -p "$dir_path"
      cp "$gdrive_file" "$local_file"
      log_message "Created new local file from Google Drive: $rel_path"
    fi
  done
}

# Function to check if Google Drive for Desktop is running
check_gdrive_app() {
  if ! pgrep "Google Drive" > /dev/null; then
    log_message "WARNING: Google Drive for Desktop doesn't appear to be running."
    log_message "Please start Google Drive from your Applications folder."
    
    # Ask if user wants to start it
    read -p "Do you want to start Google Drive now? (y/n) " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      open -a "Google Drive"
      sleep 5  # Give it a few seconds to start
    fi
  else
    log_message "Google Drive for Desktop is running."
  fi
}

# Main execution
main() {
  log_message "=== Starting Google Docs Sync on macOS ==="
  
  check_gdrive_app
  check_gdrive
  create_folder_structure
  sync_markdown_files
  sync_from_gdrive
  
  log_message "=== Sync Completed Successfully ==="
}

# Run the script
main 