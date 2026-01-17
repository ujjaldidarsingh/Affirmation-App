#!/usr/bin/env python3
"""
Valentine's App - Audio File Auto-Detector
Run this script whenever you add new audio files to automatically update index.html
"""

import os
import re
from pathlib import Path

# Audio file extensions to look for
AUDIO_EXTENSIONS = {'.m4a', '.mp3', '.wav', '.aac', '.mp4'}

# Folder mappings
FOLDERS = {
    'hype': 'hype-monstermanny-up',
    'hug': 'i-need-a-hug',
    'jokes': 'ujjal-dad-ar-jokes',
    'kidda': 'kidda-lovely-dovely'
}

def find_audio_files(folder_name):
    """Find all audio files in a folder."""
    folder_path = Path('audio') / folder_name
    if not folder_path.exists():
        return []

    audio_files = []
    for file in sorted(folder_path.iterdir()):
        if file.is_file() and file.suffix.lower() in AUDIO_EXTENSIONS:
            # Create relative path from project root
            relative_path = f"audio/{folder_name}/{file.name}"
            audio_files.append(relative_path)

    return audio_files

def generate_audio_config():
    """Generate the JavaScript audioFiles configuration."""
    lines = []
    lines.append("        // Audio files configuration - AUTO-GENERATED")
    lines.append("        // Run ./update-audio-files.py (or .sh) to update when you add new files")
    lines.append("        const audioFiles = {")

    for i, (key, folder) in enumerate(FOLDERS.items()):
        files = find_audio_files(folder)

        lines.append(f"            {key}: [")

        if files:
            for j, file_path in enumerate(files):
                comma = "," if j < len(files) - 1 else ""
                lines.append(f"                '{file_path}'{comma}")
        else:
            lines.append("                // No audio files found yet - add some audio files to this folder!")

        comma = "," if i < len(FOLDERS) - 1 else ""
        lines.append(f"            ]{comma}")

    lines.append("        };")

    return '\n'.join(lines)

def update_index_html():
    """Update the index.html file with new audio configuration."""
    index_file = Path('index.html')

    if not index_file.exists():
        print("❌ Error: index.html not found!")
        return False

    # Read the current content
    with open(index_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Create backup
    backup_file = Path('index.html.backup')
    with open(backup_file, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"💾 Backup created: {backup_file}")

    # Generate new config
    new_config = generate_audio_config()

    # Replace the audioFiles section
    # Pattern: from "const audioFiles = {" to the closing "};" before categoryIcons
    pattern = r'([ \t]*// Audio files configuration.*?\n[ \t]*const audioFiles = \{).*?(\n[ \t]*\};)'

    # Perform the replacement
    new_content = re.sub(
        pattern,
        lambda m: new_config + m.group(2),
        content,
        flags=re.DOTALL
    )

    if new_content == content:
        print("⚠️  Warning: No changes made - couldn't find audioFiles section")
        return False

    # Write back
    with open(index_file, 'w', encoding='utf-8') as f:
        f.write(new_content)

    return True

def main():
    print("🎵 Valentine's App - Audio File Scanner")
    print("=" * 50)
    print()

    # Scan folders and show summary
    print("📂 Scanning audio folders...")
    print()

    total_files = 0
    for key, folder in FOLDERS.items():
        files = find_audio_files(folder)
        total_files += len(files)

        folder_display = folder.ljust(30)
        print(f"  {folder_display} {len(files)} files")

        # Show first few files as preview
        if files:
            for file in files[:3]:
                print(f"    → {Path(file).name}")
            if len(files) > 3:
                print(f"    ... and {len(files) - 3} more")

    print()
    print("=" * 50)
    print(f"📊 Total: {total_files} audio files found")
    print()

    if total_files == 0:
        print("⚠️  No audio files found! Add some .m4a files to the audio folders.")
        print()
        return

    # Update the HTML file
    print("✏️  Updating index.html...")
    if update_index_html():
        print("✅ Success! index.html has been updated.")
        print()
        print("🎁 You can now open index.html in your browser!")
        print("   All your audio files will be available for playback.")
    else:
        print("❌ Failed to update index.html")
    print()

if __name__ == '__main__':
    main()
