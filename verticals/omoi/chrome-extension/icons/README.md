# Icons

Place PNG icons here:
- `icon16.png` — 16×16 toolbar icon
- `icon48.png` — 48×48 extension management page
- `icon128.png` — 128×128 Chrome Web Store

Generate from `icon.svg` using ImageMagick or any SVG → PNG converter.

Example:
```bash
convert -resize 16x16 icon.svg icon16.png
convert -resize 48x48 icon.svg icon48.png
convert -resize 128x128 icon.svg icon128.png
```
