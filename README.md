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

### 1. Clone This Repository

```bash
git clone https://github.com/Mreoch1/Novel_Writing_Guide.git
cd Novel_Writing_Guide
```

### 2. Set Up Google Drive Integration (Optional)

This repository includes scripts to sync your writing with Google Drive for cloud backup and collaborative editing.

1. Install the required dependencies:
   ```bash
   # For macOS
   pip3 install -r scripts/requirements.txt
   brew install coreutils findutils
   ```

2. Set up Google Drive:
   - Install [Google Drive for Desktop](https://www.google.com/drive/download/)
   - Follow the instructions in `docs/google_docs_integration.md`

3. Configure the sync script:
   - Edit `scripts/sync_to_google_docs.sh` to update your Google Drive path
   - Make the scripts executable: `chmod +x scripts/*.sh scripts/*.py`

4. Run the sync script:
   ```bash
   ./scripts/sync_to_google_docs.sh
   ```

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