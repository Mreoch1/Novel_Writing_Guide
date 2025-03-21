#!/bin/bash

# Google Docs Sync Script for Novel Writing Guide - macOS version
# This script helps automate the process of syncing local markdown files to Google Docs
# and sets up the environment after cloning the repository

# Configuration
LOCAL_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# You'll need to update this path with your specific Google Drive location
GDRIVE_SYNC_DIR="$HOME/Library/CloudStorage/GoogleDrive-Mreoch82@hotmail.com/My Drive/Doing Nothing, Badly"
# Alternative path formats:
# - $HOME/Google Drive/My Drive/Doing Nothing, Badly
# - $HOME/Library/CloudStorage/GoogleDrive-Mreoch82@hotmail.com/My Drive/Doing_Nothing_Badly
LOG_FILE="$LOCAL_PROJECT_DIR/logs/gdocs_sync.log"

# Create logs directory if it doesn't exist
mkdir -p "$LOCAL_PROJECT_DIR/logs"

# Function to log messages
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to check if this is a fresh clone
check_if_fresh_clone() {
  # Check if this appears to be a fresh git clone by looking at git logs
  # (typically a fresh clone will have very few local git operations)
  local git_log_count=$(cd "$LOCAL_PROJECT_DIR" && git reflog | wc -l | tr -d ' ')
  if [ "$git_log_count" -lt 5 ]; then
    return 0  # This is likely a fresh clone
  else
    return 1  # Not a fresh clone
  fi
}

# Function to install dependencies
install_dependencies() {
  log_message "Setting up environment for Google Docs integration..."

  # Check and install Python dependencies
  if command -v pip3 &>/dev/null; then
    log_message "Installing Python dependencies..."
    pip3 install -r "$LOCAL_PROJECT_DIR/scripts/requirements.txt"
  else
    log_message "ERROR: pip3 not found. Please install Python 3 and pip3."
    log_message "On macOS, you can run: brew install python3"
    return 1
  fi

  # Check and install required macOS tools
  if command -v brew &>/dev/null; then
    log_message "Installing required macOS tools..."
    brew install coreutils findutils
  else
    log_message "Homebrew not found. Some tools might be missing."
    log_message "If you encounter issues, please install: brew install coreutils findutils"
  fi

  # Set up Google Drive path configuration
  log_message "Setting up Google Drive configuration..."
  log_message "You'll need to configure your Google Drive path."
  log_message "Default path is set to: $GDRIVE_SYNC_DIR"
  log_message "You may need to edit this script to update it."
  
  return 0
}

# Function to setup Google Docs integration after clone
setup_after_clone() {
  log_message "First-time setup running..."

  # Install necessary dependencies
  install_dependencies
  
  # Prompt for Google Drive path configuration
  echo ""
  echo "Google Drive Integration Setup"
  echo "=============================="
  echo "To enable Google Docs integration, follow these steps:"
  echo ""
  echo "1. Make sure Google Drive for Desktop is installed"
  echo "   (Download from https://www.google.com/drive/download/)"
  echo ""
  echo "2. Configure your Google Drive path in this script:"
  echo "   Edit scripts/sync_to_google_docs.sh and update GDRIVE_SYNC_DIR"
  echo ""
  echo "3. To complete setup, install Google Drive and obtain credentials.json"
  echo "   (See docs/google_docs_integration.md for detailed instructions)"
  echo ""
  
  # Ask user if they want to continue with setup
  read -p "Would you like to continue with Google Docs integration setup? (y/n) " answer
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    # Check if Google Drive is installed and running
    check_gdrive_app
  else
    log_message "Skipping Google Docs integration setup."
    log_message "You can run this script later when you're ready to set up Google Docs integration."
  fi
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
    return 1
  else
    log_message "Google Drive directory found at $GDRIVE_SYNC_DIR"
    return 0
  fi
}

# Function to ensure Google Drive folder structure matches local structure
create_folder_structure() {
  log_message "Creating folder structure in Google Drive..."
  
  # Create main folders if they don't exist
  for dir in "src/chapters" "src/characters" "src/settings" "docs"; do
    if [ ! -d "$GDRIVE_SYNC_DIR/$dir" ]; then
      mkdir -p "$GDRIVE_SYNC_DIR/$dir"
      log_message "Created directory: $dir"
    fi
  done
}

# Function to sync markdown files to Google Drive
sync_markdown_files() {
  log_message "Syncing markdown files to Google Drive..."
  
  # Find all markdown files in the project
  find "$LOCAL_PROJECT_DIR/src" "$LOCAL_PROJECT_DIR/docs" -name "*.md" -type f | while read -r file; do
    # Get relative path
    # Use perl instead of realpath which might not be available on macOS by default
    rel_path=$(perl -e 'use File::Spec; print File::Spec->abs2rel($ARGV[0], $ARGV[1])' "$file" "$LOCAL_PROJECT_DIR")
    dir_path=$(dirname "$rel_path")
    file_name=$(basename "$file")
    
    # Create target directory if it doesn't exist
    target_dir="$GDRIVE_SYNC_DIR/$dir_path"
    mkdir -p "$target_dir"
    
    # Handle chapter versioning - only keep latest version
    # Extract chapter number if this is a chapter file
    if [[ "$file_name" =~ chapter_([0-9]+)(_v[0-9]+)?\.md ]]; then
      chapter_num="${BASH_REMATCH[1]}"
      # Remove any old versions with the same chapter number
      find "$target_dir" -name "chapter_${chapter_num}_v*" -type f -delete 2>/dev/null
      # If this file doesn't have a version suffix but previous versions exist
      if [[ ! "$file_name" =~ _v[0-9]+ ]]; then
        # Remove any versioned files with same chapter number
        find "$target_dir" -name "chapter_${chapter_num}_v*" -type f -delete 2>/dev/null
      fi
    fi
    
    # Copy the file to Google Drive
    cp "$file" "$target_dir/$file_name"
    log_message "Synced: $rel_path"
  done
  
  # Also sync root markdown files used for writing guides
  find "$LOCAL_PROJECT_DIR" -maxdepth 1 -name "*.md" -type f | while read -r file; do
    file_name=$(basename "$file")
    cp "$file" "$GDRIVE_SYNC_DIR/$file_name"
    log_message "Synced: $file_name"
  done
}

# Function to sync back from Google Drive to local
sync_from_gdrive() {
  log_message "Checking for modified files in Google Drive..."
  
  find "$GDRIVE_SYNC_DIR" -name "*.md" -type f | while read -r gdrive_file; do
    # Get relative path
    # Use perl instead of realpath which might not be available on macOS by default
    rel_path=$(perl -e 'use File::Spec; print File::Spec->abs2rel($ARGV[0], $ARGV[1])' "$gdrive_file" "$GDRIVE_SYNC_DIR")
    local_file="$LOCAL_PROJECT_DIR/$rel_path"
    
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

# Create a post-clone hook for Git
create_git_hooks() {
  log_message "Setting up Git hooks for automatic sync..."
  
  # Create post-merge hook (runs after git pull)
  hooks_dir="$LOCAL_PROJECT_DIR/.git/hooks"
  post_merge_hook="$hooks_dir/post-merge"
  
  mkdir -p "$hooks_dir"
  
  cat > "$post_merge_hook" << 'EOF'
#!/bin/bash
# Post-merge hook to run the sync script after git pull
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/scripts"
"$SCRIPT_DIR/sync_to_google_docs.sh"
EOF
  
  chmod +x "$post_merge_hook"
  log_message "Created post-merge Git hook for automatic sync"
}

# Main execution
main() {
  log_message "=== Starting Google Docs Sync on macOS ==="
  
  # Check if this is a fresh clone
  if check_if_fresh_clone; then
    setup_after_clone
  fi
  
  # Check if Google Drive is running and accessible
  check_gdrive_app
  
  # Only continue with sync if Google Drive is accessible
  if check_gdrive; then
    create_folder_structure
    sync_markdown_files
    sync_from_gdrive
    create_git_hooks
    
    log_message "=== Sync Completed Successfully ==="
  else
    log_message "=== Sync Failed: Google Drive not accessible ==="
  fi
}

# Run the script
main 