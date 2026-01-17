#!/bin/bash

# Simple script to list all your audio files
# This helps you see what to add to index.html

echo "🎵 Your Audio Files"
echo "═══════════════════════════════════════════════════"
echo ""

# Function to list files for a category
list_category() {
    folder=$1
    category_name=$2

    echo "📂 $category_name:"
    echo "   Folder: audio/$folder/"
    echo ""

    files=$(find "audio/$folder" -type f \( -name "*.m4a" -o -name "*.mp3" -o -name "*.wav" -o -name "*.aac" \) 2>/dev/null | sort)

    if [ -z "$files" ]; then
        echo "   ⚠️  No audio files found"
        echo ""
        return
    fi

    echo "   Files to add to index.html:"
    echo "   ─────────────────────────────"

    while IFS= read -r file; do
        filename=$(basename "$file")
        echo "        'audio/$folder/$filename',"
    done <<< "$files"

    echo ""
    count=$(echo "$files" | wc -l)
    echo "   Total: $count files"
    echo ""
}

# List all categories
list_category "hype-monstermanny-up" "Hype MonsterManny up"
list_category "i-need-a-hug" "I need a hug"
list_category "ujjal-dad-ar-jokes" "Ujjal Dad-ar Jokes"
list_category "kidda-lovely-dovely" "Kidda(n) lovely dovely"

echo "═══════════════════════════════════════════════════"
echo ""
echo "💡 How to use this:"
echo "   1. Copy the 'audio/...' lines above"
echo "   2. Open index.html"
echo "   3. Find the 'const audioFiles = {' section (around line 302)"
echo "   4. Paste your file paths into the appropriate category"
echo "   5. Remove the placeholder message1.m4a, message2.m4a lines"
echo ""
echo "Example for jokes category:"
echo "   jokes: ["
echo "        'audio/ujjal-dad-ar-jokes/joke1.m4a',"
echo "        'audio/ujjal-dad-ar-jokes/joke2.m4a',"
echo "        'audio/ujjal-dad-ar-jokes/joke3.m4a'"
echo "   ],"
echo ""
