# Google Docs Integration Guide

## Setup Process for macOS

### 1. Create a Google Docs Structure
1. Create a main folder in Google Drive called "Doing Nothing, Badly"
2. Create subfolders that mirror our local project structure:
   - `Chapters`
   - `Characters`
   - `Settings`
   - `Documentation`

### 2. Set Up Google Drive for Mac
1. Download and install [Google Drive for Desktop](https://www.google.com/drive/download/) on your Mac
2. Sign in with your Google account
3. Configure the app to sync specific folders:
   - Click the Google Drive icon in your menu bar
   - Select the settings icon (gear) and choose "Preferences"
   - Go to "Google Drive" tab
   - Set up the sync settings as needed:
     - Choose "Mirror files" for selective sync
     - Or select "Stream files" for on-demand access without using local storage

### 3. Locate Your Google Drive Folder
On macOS, Google Drive is typically located in one of these locations:
- `~/Library/CloudStorage/GoogleDrive-your_email@gmail.com/My Drive/`
- `~/Google Drive/`
- `~/Google Drive/My Drive/`

You'll need to update the path in the sync script to match your actual Google Drive location.

### 4. Working with Manuscript Files
For optimal compatibility between Markdown and Google Docs:

#### Option 1: Direct Sync (Simplest)
1. Save all manuscript files as Google Docs format (.gdoc)
2. Edit either locally or in Google Docs
3. Changes sync automatically

#### Option 2: Markdown Workflow (More Technical)
1. Install a Google Docs add-on like "Docs to Markdown"
   - Open a Google Doc
   - Go to Extensions > Add-ons > Get add-ons
   - Search for "Docs to Markdown" and install it
2. When editing in Google Docs, export to Markdown format
3. When editing locally in Markdown, use our converter tool to import to Google Docs

### 5. Automating the Process with Scripts
We've created macOS-compatible scripts in the `scripts` directory:

1. `sync_to_google_docs.sh` - Syncs files between your local project and Google Drive
2. `md_to_gdoc.py` - Converts between Markdown and Google Docs formats

#### Setting Up the Scripts:
1. Open Terminal on your Mac
2. Navigate to the project directory: `cd /path/to/Doing_Nothing_Badly`
3. Make the scripts executable: `chmod +x scripts/sync_to_google_docs.sh scripts/md_to_gdoc.py`
4. Install Python dependencies: `pip3 install -r scripts/requirements.txt`

## Recommended Workflow

1. **Creating New Chapters**:
   - Create the file locally in proper manuscript format
   - Save to your synced folder
   - Run the sync script to copy to Google Drive

2. **Collaborative Editing**:
   - Share the Google Doc with collaborators
   - All edits and comments will sync back to your local files

3. **Version Control**:
   - Major revisions should be committed to your repository
   - Use Google Docs' version history for tracking smaller changes

## Running on macOS

### First-Time Setup:
1. Edit the `scripts/sync_to_google_docs.sh` file to update the Google Drive path:
   - Look for the line: `GDRIVE_SYNC_DIR="$HOME/Library/CloudStorage/GoogleDrive-your_email@gmail.com/My Drive/Doing Nothing, Badly"`
   - Replace `your_email@gmail.com` with your actual Gmail address
   - Update the path if your Google Drive is located elsewhere

2. Run the script from Terminal:
   ```bash
   cd /path/to/Doing_Nothing_Badly
   ./scripts/sync_to_google_docs.sh
   ```

3. The script will:
   - Check if Google Drive is running
   - Create the necessary folder structure
   - Sync all your local markdown files to Google Drive

### Regular Use:
1. Use the sync script after creating or modifying files:
   ```bash
   ./scripts/sync_to_google_docs.sh
   ```

2. Convert markdown to Google Docs when needed:
   ```bash
   ./scripts/md_to_gdoc.py --to-gdoc src/chapters/chapter_01_formatted.md
   ```

## Potential Issues and Solutions

| Issue | Solution |
|-------|----------|
| Google Drive location not found | Check your actual Google Drive path in Finder and update the script |
| Script errors about missing commands | Install missing tools: `brew install coreutils findutils` |
| Permission denied | Run `chmod +x scripts/*.sh scripts/*.py` to make scripts executable |
| Python module not found | Run `pip3 install -r scripts/requirements.txt` |
| Slow synchronization | Consider using selective sync in Google Drive preferences |

## Export for Submission

When ready to submit your manuscript:
1. Open the Google Doc
2. Go to File > Download > Microsoft Word (.docx)
3. Verify formatting matches submission requirements
4. Adjust headers, page numbers, and margins if needed in Word 