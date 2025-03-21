#!/usr/bin/env python3

"""
Markdown to Google Docs Converter for "Doing Nothing, Badly" - macOS version

This script helps convert markdown files to Google Docs format and vice versa.
It preserves proper manuscript formatting during conversion.

Requirements:
- pip3 install markdown google-api-python-client google-auth-httplib2 google-auth-oauthlib

Usage:
- To convert markdown to Google Docs: python3 md_to_gdoc.py --to-gdoc path/to/file.md
- To convert Google Docs to markdown: python3 md_to_gdoc.py --to-md google_doc_id
"""

import os
import sys
import json
import argparse
import markdown
import re
from datetime import datetime
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# Google Docs API setup
SCOPES = ['https://www.googleapis.com/auth/documents', 'https://www.googleapis.com/auth/drive']
TOKEN_PATH = 'token.json'
CREDENTIALS_PATH = 'credentials.json'

def get_credentials():
    """Get and refresh Google API credentials."""
    creds = None
    if os.path.exists(TOKEN_PATH):
        try:
            with open(TOKEN_PATH, 'r') as token:
                creds = Credentials.from_authorized_user_info(json.loads(token.read()), SCOPES)
        except json.JSONDecodeError:
            print(f"Error: Invalid token file. Will recreate authentication.")
            os.remove(TOKEN_PATH)
            creds = None
    
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            try:
                creds.refresh(Request())
            except Exception as e:
                print(f"Error refreshing credentials: {e}")
                print("Recreating authentication token...")
                os.remove(TOKEN_PATH) if os.path.exists(TOKEN_PATH) else None
                return get_credentials()
        else:
            try:
                flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS_PATH, SCOPES)
                creds = flow.run_local_server(port=0)
            except FileNotFoundError:
                print(f"Error: credentials.json not found in {os.getcwd()}")
                print("Please download OAuth credentials from Google Cloud Console")
                print("and save as 'credentials.json' in this directory.")
                sys.exit(1)
        
        with open(TOKEN_PATH, 'w') as token:
            token.write(creds.to_json())
    
    return creds

def markdown_to_gdoc(markdown_path, folder_id=None):
    """Convert a markdown file to Google Docs format and upload it."""
    # Check if file exists
    if not os.path.exists(markdown_path):
        print(f"Error: File {markdown_path} does not exist")
        return None
    
    # Read markdown file
    with open(markdown_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract author info and title
    author_info = ""
    title = os.path.basename(markdown_path).replace('.md', '')
    
    # Preserve manuscript formatting
    match = re.search(r'^(.*?)\n\s*(?:About \d+ words)\s*\n\n+?([A-Z\s]+)\n\n+?By (.*?)$', content, re.DOTALL)
    if match:
        author_info = match.group(1)
        title = match.group(2).strip()
        author = match.group(3).strip()
    
    # Convert markdown to HTML
    html_content = markdown.markdown(content)
    
    try:
        # Authenticate
        creds = get_credentials()
        docs_service = build('docs', 'v1', credentials=creds)
        drive_service = build('drive', 'v3', credentials=creds)
        
        # Create a new Google Doc
        doc_metadata = {
            'name': title,
            'mimeType': 'application/vnd.google-apps.document'
        }
        
        if folder_id:
            doc_metadata['parents'] = [folder_id]
        
        doc = drive_service.files().create(body=doc_metadata).execute()
        doc_id = doc.get('id')
        
        # Insert content into the document
        requests = [
            {
                'insertText': {
                    'location': {
                        'index': 1
                    },
                    'text': content
                }
            }
        ]
        
        docs_service.documents().batchUpdate(
            documentId=doc_id, 
            body={'requests': requests}
        ).execute()
        
        print(f"Created Google Doc: {title} (ID: {doc_id})")
        print(f"View at: https://docs.google.com/document/d/{doc_id}/edit")
        
        return doc_id
    
    except Exception as e:
        print(f"Error creating Google Doc: {e}")
        return None

def gdoc_to_markdown(doc_id, output_path=None):
    """Convert a Google Doc to markdown format and save it locally."""
    try:
        # Authenticate
        creds = get_credentials()
        docs_service = build('docs', 'v1', credentials=creds)
        drive_service = build('drive', 'v3', credentials=creds)
        
        # Get document content
        document = docs_service.documents().get(documentId=doc_id).execute()
        doc_content = document.get('body').get('content')
        doc_title = document.get('title')
        
        # Get document metadata
        file = drive_service.files().get(fileId=doc_id).execute()
        
        # Extract text from the document
        text = ""
        for element in doc_content:
            if 'paragraph' in element:
                for paragraph_element in element['paragraph']['elements']:
                    if 'textRun' in paragraph_element:
                        text += paragraph_element['textRun']['content']
        
        # Determine output path
        if not output_path:
            output_path = f"{doc_title.replace(' ', '_')}.md"
        
        # Write to local file
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(text)
        
        print(f"Saved markdown to: {output_path}")
        return output_path
    
    except Exception as e:
        print(f"Error converting Google Doc to markdown: {e}")
        return None

def check_prerequisites():
    """Check if all prerequisites are met for macOS."""
    try:
        import markdown
        import google.auth
    except ImportError as e:
        module = str(e).split("'")[1]
        print(f"Missing required Python module: {module}")
        print("Please install requirements using:")
        print("  pip3 install -r requirements.txt")
        return False
    
    # Check for credentials
    if not os.path.exists(CREDENTIALS_PATH):
        script_dir = os.path.dirname(os.path.realpath(__file__))
        print(f"Error: credentials.json not found in {script_dir}")
        print("\nTo set up Google API access:")
        print("1. Go to https://console.cloud.google.com/")
        print("2. Create a project and enable Google Drive & Docs APIs")
        print("3. Create OAuth credentials (Desktop app)")
        print("4. Download as credentials.json to this directory")
        return False
    
    return True

def main():
    # Check prerequisites first
    if not check_prerequisites():
        sys.exit(1)
        
    parser = argparse.ArgumentParser(description='Convert between Markdown and Google Docs')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--to-gdoc', help='Convert Markdown to Google Docs')
    group.add_argument('--to-md', help='Convert Google Docs to Markdown')
    parser.add_argument('--output', help='Output file path')
    parser.add_argument('--folder-id', help='Google Drive folder ID')
    
    args = parser.parse_args()
    
    if args.to_gdoc:
        markdown_to_gdoc(args.to_gdoc, args.folder_id)
    elif args.to_md:
        gdoc_to_markdown(args.to_md, args.output)

if __name__ == "__main__":
    main() 