# How to Add Audio Files

This guide shows you how to add your recorded messages to the app.

## Simple 3-Step Process

### Step 1: Add Your Audio Files

Just drag and drop your audio files into the category folders:

```
audio/
├── hype-monstermanny-up/      ← Drop motivational messages here
├── i-need-a-hug/              ← Drop comfort messages here
├── ujjal-dad-ar-jokes/        ← Drop funny jokes here
└── kidda-lovely-dovely/       ← Drop romantic messages here
```

**Supported formats:** `.m4a`, `.mp3`, `.wav`, `.aac`

**File names don't matter!** Name them anything you want:
- ✅ `joke 1.m4a`
- ✅ `my funny story.m4a`
- ✅ `Recording 001.m4a`
- ✅ `I love you.mp3`

The app will automatically find and play ALL audio files in each folder.

### Step 2: Run the Update Script

After adding files, you need to run a script once to update the app.

**Choose ONE method:**

#### Method A: Double-Click (Easiest!)

1. Find the file `update-audio-files.py` in your folder
2. **Double-click it**
3. A terminal window will open and show you what files were found
4. Done! ✅

#### Method B: Terminal (if double-click doesn't work)

1. Open Terminal
2. Navigate to your project folder:
   ```bash
   cd /path/to/your/valentines-app
   ```
3. Run the Python script:
   ```bash
   python3 update-audio-files.py
   ```

   OR run the shell script:
   ```bash
   ./update-audio-files.sh
   ```

You'll see output like:
```
🎵 Valentine's App - Audio File Scanner
==================================================

📂 Scanning audio folders...

  hype-monstermanny-up           3 files
    → hype1.m4a
    → hype2.m4a
    → motivate.m4a

  i-need-a-hug                   5 files
    → comfort1.m4a
    → hug message.m4a
    ... and 3 more

==================================================
📊 Total: 15 audio files found

✏️  Updating index.html...
💾 Backup created: index.html.backup
✅ Success! index.html has been updated.

🎁 You can now open index.html in your browser!
```

### Step 3: Test It!

1. Open `index.html` in your browser
2. Click on a category
3. Your messages should play! 🎵

## Adding More Files Later

Anytime you want to add more audio files:

1. Drop new files into the folders
2. Run `update-audio-files.py` again
3. Refresh the browser

That's it!

## Troubleshooting

**"No audio files found"**
- Make sure files are in the correct folders
- Check that files have the right extension (.m4a, .mp3, .wav, .aac)

**"Python command not found"**
- Try `python` instead of `python3`
- Or use the shell script: `./update-audio-files.sh`

**Audio still not playing**
- Check the browser console (press F12 or Cmd+Option+I)
- Look for error messages
- Make sure the file isn't corrupted (try playing it in iTunes/Music first)

**Script won't run when double-clicked**
- Right-click `update-audio-files.py`
- Select "Open With" → "Terminal"
- Or use Method B (Terminal)

## What the Script Does

The script:
1. 🔍 Scans all your audio folders
2. 📝 Finds every audio file
3. ✏️ Updates `index.html` with the file list
4. 💾 Creates a backup of your old `index.html`

You never have to edit code manually!

---

**Need help?** Check the error messages in the terminal or browser console.
