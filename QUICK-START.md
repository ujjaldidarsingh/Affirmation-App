# 🎁 Quick Start Guide

## Super Simple 4-Step Process

### Step 1: Add Your Audio Files
Drop your recorded messages into these folders:
```
audio/hype-monstermanny-up/     ← motivational messages
audio/i-need-a-hug/             ← comfort messages
audio/ujjal-dad-ar-jokes/       ← your jokes
audio/kidda-lovely-dovely/      ← romantic messages
```

Name them simply: `message1.m4a`, `message2.m4a`, etc.

### Step 2: List Your Files
In Terminal, run:
```bash
./list-audio-files.sh
```

This shows you all your files in the right format.

### Step 3: Update index.html
1. Open `index.html` in a text editor
2. Find line 302: `const audioFiles = {`
3. Copy-paste your file paths from Step 2
4. Save the file

### Step 4: Test It
Double-click `index.html` to open in your browser. Test all categories!

---

## 🌐 To Put It Online (GitHub Pages)

See `DEPLOY-TO-GITHUB-PAGES.md` for detailed instructions.

**Quick version:**
1. Push your files to GitHub
2. Enable GitHub Pages in repo Settings → Pages
3. Share the URL with your wife!

---

## 🆘 Help! It's Not Working

**Audio won't play?**
- Check browser console (press F12)
- Make sure file names in `index.html` match your actual files exactly
- File names are case-sensitive: `Message1.m4a` ≠ `message1.m4a`

**Can't run the list script?**
```bash
chmod +x list-audio-files.sh
./list-audio-files.sh
```

---

That's it! Questions? Check the other README files for more details.
