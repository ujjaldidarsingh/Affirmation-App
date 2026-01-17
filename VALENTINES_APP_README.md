# Valentine's Day Message App 💕

A beautiful, personalized app to share recorded messages of love, affirmation, support, and humor with your wife.

## Features

✨ **Beautiful Greeting Screen** - Opens with a randomized loving message
💕 **4 Message Categories** - Affirmations, Support, Funny, and Love Notes
🎵 **Smart Playback** - Never repeats a message until all have been played
🎨 **Soft Pastel Design** - Elegant, minimal Valentine's theme
📱 **Mobile-Friendly** - Works perfectly on any device
💾 **Works Offline** - No internet connection needed

## How to Set Up

### Step 1: Record Your Messages

Record your personalized messages in M4A/AAC format. You can use:
- **iPhone Voice Memos** (saves as M4A automatically)
- **Any audio recording app** that exports to M4A/AAC

### Step 2: Organize Your Audio Files

Place your recorded messages in the appropriate folders:

```
audio/
├── affirmations/    (Messages of love and appreciation)
│   ├── message1.m4a
│   ├── message2.m4a
│   └── message3.m4a
├── support/         (Encouraging and supportive words)
│   ├── message1.m4a
│   └── message2.m4a
├── funny/           (Lighthearted and humorous messages)
│   ├── message1.m4a
│   └── message2.m4a
└── love/            (Romantic declarations)
    ├── message1.m4a
    └── message2.m4a
```

**Important:** You can name the files anything you want (e.g., `wife-affirmation-1.m4a`, `love-note.m4a`), just make sure they end with `.m4a`

### Step 3: Update the Code

Open `index.html` in a text editor and find this section (around line 224):

```javascript
const audioFiles = {
    affirmations: [
        'audio/affirmations/message1.m4a',
        'audio/affirmations/message2.m4a',
        'audio/affirmations/message3.m4a'
        // Add more files as you record them
    ],
    support: [
        'audio/support/message1.m4a',
        'audio/support/message2.m4a',
        'audio/support/message3.m4a'
        // Add more files as you record them
    ],
    funny: [
        'audio/funny/message1.m4a',
        'audio/funny/message2.m4a',
        'audio/funny/message3.m4a'
        // Add more files as you record them
    ],
    love: [
        'audio/love/message1.m4a',
        'audio/love/message2.m4a',
        'audio/love/message3.m4a'
        // Add more files as you record them
    ]
};
```

**Update this list** to match your actual audio file names. For example:

```javascript
const audioFiles = {
    affirmations: [
        'audio/affirmations/youre-amazing.m4a',
        'audio/affirmations/so-proud.m4a',
        'audio/affirmations/beautiful-soul.m4a',
        'audio/affirmations/incredible-person.m4a'
    ],
    support: [
        'audio/support/you-got-this.m4a',
        'audio/support/believe-in-you.m4a'
    ],
    // ... and so on
};
```

### Step 4: Test It

1. Open `index.html` in a web browser (Chrome, Safari, Firefox, etc.)
2. Click through each category to make sure audio plays correctly
3. Check that messages don't repeat until all have been played

## How to Share with Your Wife

### Option 1: Local Files (Recommended)
1. Copy the entire folder (including `index.html` and `audio/` folder) to a USB drive
2. She can open `index.html` directly from the USB drive
3. Works without internet!

### Option 2: Mobile Device
1. Use a file transfer app to copy the folder to her phone
2. She can open `index.html` in any mobile browser
3. Suggest adding to home screen for easy access

### Option 3: Host Online (Optional)
- Upload to GitHub Pages, Netlify, or any static hosting
- She can access via a URL from anywhere

## Customization Ideas

Want to personalize it further? Here are some easy tweaks:

### Change Her Name
Find this line (around line 194) and update it:
```html
<h1 class="greeting-title">Hello Beautiful 💕</h1>
```

### Add More Greeting Messages
Find the `greetingMessages` array (around line 212) and add your own:
```javascript
const greetingMessages = [
    "You make every day brighter just by being you",
    "Your custom message here",
    // Add as many as you want!
];
```

### Change Colors
The app uses soft pastels, but you can adjust the gradient in the `<style>` section if you prefer different colors.

## Troubleshooting

**Audio won't play?**
- Check that file paths in the code match your actual file names
- Make sure files are in M4A format
- Try opening the browser console (F12) to see any error messages

**Messages repeating too soon?**
- The app uses localStorage to track played messages
- Each category resets only after ALL messages in that category have been played
- Clear browser data to reset if needed

## Tips for Recording

- **Keep it short** - 15-30 seconds works great
- **Speak from the heart** - Be authentic and genuine
- **Vary the tone** - Mix serious, playful, and romantic
- **Record in a quiet space** - Minimize background noise
- **Don't overthink it** - She'll love hearing your voice!

---

Made with 💕 for a Valentine's Day surprise

Enjoy your gift!
