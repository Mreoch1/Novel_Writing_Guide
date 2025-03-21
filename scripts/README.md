# Google Docs Integration for "Doing Nothing, Badly" - macOS

This directory contains scripts to help you integrate the "Doing Nothing, Badly" novel project with Google Docs for collaborative editing and cloud backup. These scripts have been optimized for macOS.

## Setup Instructions for macOS

### 1. Install Required Software

**Google Drive for Desktop on macOS:**
1. Download from [Google Drive for Desktop](https://www.google.com/drive/download/)
2. Install the app to your Applications folder
3. Sign in with your Google account
4. Configure through the menu bar icon:
   - Click the Google Drive icon in your menu bar
   - Click the gear icon and select "Preferences"
   - Configure sync settings as needed

**Python Dependencies:**
macOS comes with Python, but you may need to install pip. Run these commands in Terminal:
```bash
# Install pip if not already installed
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

# Install dependencies
pip3 install -r requirements.txt
```

**Required Mac Utilities:**
Some of our scripts use utilities that may not be installed by default on macOS:
```bash
# Using Homebrew (recommended)
brew install coreutils findutils

# Or use MacPorts if you prefer
# sudo port install coreutils findutils
```

### 2. Google API Setup (One-time)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project
3. Enable the Google Drive API and Google Docs API
4. Create OAuth credentials
   - Application type: Desktop app
   - Download the credentials as `credentials.json`
   - Place this file in the `scripts` directory
5. The first time you run the script, it will open a browser window for authentication

### 3. Configure the Sync Script for Your Mac

Edit `sync_to_google_docs.sh` to update your Google Drive path:

1. Open the script in your text editor
2. Find this line: 
   ```
   GDRIVE_SYNC_DIR="$HOME/Library/CloudStorage/GoogleDrive-your_email@gmail.com/My Drive/Doing Nothing, Badly"
   ```
3. Replace `your_email@gmail.com` with your actual Gmail address
4. Verify the path by checking where Google Drive stores files on your Mac:
   - Common paths include:
     - `~/Library/CloudStorage/GoogleDrive-your_email@gmail.com/My Drive/`
     - `~/Google Drive/`
     - `~/Google Drive/My Drive/`

## Usage on macOS

### Make Scripts Executable
First, make sure the scripts are executable:
```bash
chmod +x sync_to_google_docs.sh md_to_gdoc.py
```

### Sync Local Files to Google Drive

This will copy all your local markdown files to Google Drive, maintaining folder structure:

```bash
./sync_to_google_docs.sh
```

### Convert Markdown to Google Docs

Convert a markdown file to a properly formatted Google Doc:

```bash
python3 ./md_to_gdoc.py --to-gdoc ../src/chapters/chapter_01_formatted.md
```

### Convert Google Doc Back to Markdown

Convert a Google Doc back to markdown format:

```bash
python3 ./md_to_gdoc.py --to-md GOOGLE_DOC_ID --output ../src/chapters/chapter_new.md
```

## Recommended Workflow for Mac Users

1. **Initial Setup:**
   - Make sure Google Drive for Desktop is installed and running (check menu bar)
   - Run `./sync_to_google_docs.sh` to create folder structure and sync all files
   
2. **Writing New Content:**
   - Create new chapters locally using the proper manuscript format
   - Run `./sync_to_google_docs.sh` to copy to Google Drive
   - Optionally convert to Google Docs format using `python3 ./md_to_gdoc.py`
   
3. **Collaborative Editing:**
   - Share Google Docs with collaborators
   - When edits are complete, convert back to markdown if needed
   - Run `./sync_to_google_docs.sh` to sync changes back to local files

4. **Regular Backup:**
   - Schedule regular runs of the sync script
   - For automated backups on Mac, create a LaunchAgent:
     ```bash
     mkdir -p ~/Library/LaunchAgents
     ```
   - Create a plist file (see example below) to run the script hourly

## macOS Automation

To run the sync script automatically on your Mac:

1. Create a LaunchAgent:
```bash
nano ~/Library/LaunchAgents/com.doingnothing.sync.plist
```

2. Add the following content (adjust paths as needed):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.doingnothing.sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/YOUR_USERNAME/Doing_Nothing_Badly/scripts/sync_to_google_docs.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

3. Load the LaunchAgent:
```bash
launchctl load ~/Library/LaunchAgents/com.doingnothing.sync.plist
```

## Troubleshooting on macOS

**Authentication Issues:**
- Delete `token.json` and run the script again to re-authenticate

**Sync Problems:**
- Check if Google Drive icon is visible in your menu bar
- Verify folder paths in the script match your actual Google Drive location
- Check file permissions: `ls -la` should show read/write permissions

**Command Not Found Errors:**
- If you see `realpath: command not found`, install GNU coreutils:
  ```bash
  brew install coreutils
  ```

**Python Issues:**
- If scripts fail due to missing modules, re-run:
  ```bash
  pip3 install -r requirements.txt
  ```
- If you have multiple Python versions, be explicit:
  ```bash
  python3 ./md_to_gdoc.py --to-gdoc ../src/chapters/chapter_01_formatted.md
  ```

**macOS Security Restrictions:**
- If macOS prevents running the scripts due to security settings:
  1. Right-click the script and choose "Open"
  2. Click "Open" in the security dialog
  3. For future runs, the script will be allowed 