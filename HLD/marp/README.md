# PayPal Mobile Development HLD Presentation

This directory contains a Marp-based High-Level Design presentation for the PayPal Mobile Development course.

## Structure

```
marp/
├── assets/           # Images and resources
│   ├── ga-logo.svg  # GA branding
│   └── developers.png (needed)
├── theme.css        # Custom GA theme
├── presentation.md  # Main presentation content
└── README.md       # This file
```

## Required Setup

1. Install Marp CLI globally:
```bash
npm install -g @marp-team/marp-cli
```

2. Required Assets:
- Add `developers.png` to the assets folder (illustration for learner personas slide)

## Preview Presentation

To preview the presentation in VS Code:
1. Install "Marp for VS Code" extension
2. Open `presentation.md`
3. Press `Cmd/Ctrl + Shift + P`
4. Select "Marp: Open Preview"

## Export Options

Export to PowerPoint:
```bash
marp presentation.md --pptx
```

Export to PDF:
```bash
marp presentation.md --pdf
```

## Theme Customization

The `theme.css` file contains GA branding elements and slide layouts:
- Color variables
- Typography settings
- Slide templates
- Custom components

## Missing Assets

The following assets need to be added:
1. `assets/developers.png` - Illustration for the Learner Personas slide
   - Should show diverse group of developers
   - Matches GA's inclusive design principles
   - Recommended size: 400x300px
