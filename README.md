# Novel Writing Guide

A comprehensive framework for writing, formatting, and managing novel projects with Google Docs integration.

## Project Overview

This repository provides a complete set of tools and guidelines for novel writing, including:

1. **Writing Guides**: Technical rules, style guides, character development, plot structure, and more
2. **Project Structure**: Organized folders for chapters, characters, and settings
3. **Manuscript Formatting**: Templates and guidelines for industry-standard manuscript submission
4. **Google Docs Integration**: Scripts for syncing with Google Drive for cloud backup and collaborative editing

## Repository Structure

```
.
├── docs/                      # Documentation files
│   ├── google_docs_integration.md  # Google Docs setup guide
│   └── project_summary.md     # Project overview
├── scripts/                   # Utility scripts
│   ├── md_to_gdoc.py          # Convert markdown to Google Docs
│   ├── sync_to_google_docs.sh # Sync files with Google Drive
│   └── requirements.txt       # Python dependencies
├── src/                       # Source files
│   ├── chapters/              # Novel chapters
│   ├── characters/            # Character profiles
│   └── settings/              # World building and settings
├── formatting_and_submission.md  # Submission guidelines
├── character_development.md      # Character creation guide
├── plot_structure.md             # Plot development guide
├── pacing_and_scenes.md          # Scene construction guide
├── style_guide.md                # Writing style reference
├── technical_rules.md            # Technical writing rules
└── world_building.md             # Setting development guide
```

## Getting Started

### 1. Clone This Repository with Automatic Setup

```bash
git clone https://github.com/Mreoch1/Novel_Writing_Guide.git my_new_novel
cd my_new_novel
```

When you clone the repository, the setup script will automatically:
- Detect that this is a fresh clone
- Guide you through setting up Google Docs integration
- Install required dependencies
- Create necessary folder structures
- Set up Git hooks for automatic syncing

If you prefer to manually set up Google Drive integration later, you can skip the automatic setup and run it manually when ready:

```bash
./scripts/sync_to_google_docs.sh
```

### 2. Google Drive Integration Setup

The automatic setup will help you configure Google Drive integration, but you'll need to:

1. **Install Google Drive for Desktop**:
   - Download from: https://www.google.com/drive/download/
   - Sign in with your Google account

2. **Configure Google Drive Path**:
   - Edit `scripts/sync_to_google_docs.sh` 
   - Update the `GDRIVE_SYNC_DIR` variable with your actual Google Drive path
   - Common paths: 
     - `$HOME/Library/CloudStorage/GoogleDrive-youremail@example.com/My Drive/Novel_Writing_Guide`
     - `$HOME/Google Drive/My Drive/Novel_Writing_Guide`

3. **Set Up Google API Access** (if using conversion features):
   - Follow instructions in `docs/google_docs_integration.md`
   - Create a Google Cloud project and enable necessary APIs
   - Download credentials.json to the scripts directory

4. **Sync Your Files**:
   - After configuration, files will automatically sync after git pull
   - You can manually sync anytime by running: `./scripts/sync_to_google_docs.sh`

## Using the Writing Guides

The repository includes seven comprehensive writing guides:

1. **Technical Rules (`technical_rules.md`)**: Foundational writing mechanics and structures
2. **Style Guide (`style_guide.md`)**: Developing consistent, effective writing style
3. **Character Development (`character_development.md`)**: Creating compelling characters
4. **Plot & Story Structure (`plot_structure.md`)**: Building effective narratives
5. **Pacing & Scene Construction (`pacing_and_scenes.md`)**: Crafting engaging scenes
6. **World-Building (`world_building.md`)**: Creating immersive settings
7. **Formatting & Manuscript Preparation (`formatting_and_submission.md`)**: Professional presentation

## Writing Workflow

1. **Plan your novel**:
   - Develop characters using character_development.md guidelines
   - Structure your plot with plot_structure.md
   - Build your world using world_building.md

2. **Write your chapters**:
   - Create chapter files in src/chapters/
   - Follow the style_guide.md and technical_rules.md
   - Use pacing_and_scenes.md for scene construction

3. **Format for submission**:
   - Use formatting_and_submission.md as reference
   - Format chapters according to industry standards
   - Export final manuscript in the proper format

4. **Collaborate with Google Docs** (optional):
   - Run the sync script to push to Google Drive
   - Share documents with beta readers or editors
   - Sync changes back to your local repository

## Google Docs Integration

The Google Docs integration allows you to:

1. **Sync your files**: Keep local files and Google Drive in sync
2. **Convert formats**: Transform Markdown files to Google Docs and back
3. **Collaborate**: Share documents with others for feedback and editing
4. **Access anywhere**: Work on your novel from any device with internet access

Detailed instructions are available in `docs/google_docs_integration.md`.

## Customizing for Your Novel

1. **Update the project structure** to fit your novel's needs
2. **Modify the character templates** in src/characters/
3. **Create your own writing guides** or adapt the existing ones
4. **Configure the Google Drive sync** to match your workflow

## License

This project is shared under the MIT License - see the LICENSE file for details.

## Acknowledgements

This framework combines best practices from numerous writing resources and tools to create a comprehensive novel writing system. 