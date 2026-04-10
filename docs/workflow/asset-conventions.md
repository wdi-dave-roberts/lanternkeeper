# Asset Conventions

Rules for naming, formatting, and organizing art, audio, and font assets. Following these conventions keeps the project clean and prevents issues with Godot's import system.

## Directory Structure

```
assets/
├── sprites/          # All image assets
│   ├── aetherling/   # Character sprites, organized by character
│   ├── ui/           # Interface elements (buttons, icons)
│   └── regions/      # Background art, per region
│       ├── lantern-clearing/
│       ├── fog-forest/
│       └── moss-garden/
├── audio/
│   ├── music/        # Background music loops
│   ├── sfx/          # Sound effects
│   └── ambient/      # Atmospheric loops
└── fonts/            # Custom fonts
```

Create subdirectories as needed. The structure above is a starting point — if a new region or character needs a folder, create it.

## File Naming

**All lowercase, hyphens between words. No spaces, no underscores, no capital letters.**

| Good | Bad |
|------|-----|
| `aetherling-idle.png` | `Aetherling Idle.png` |
| `fog-forest-ambient.ogg` | `fogForestAmbient.ogg` |
| `lantern-glow-01.png` | `lantern_glow_1.png` |
| `menu-tap.wav` | `Menu Tap.WAV` |

**Why this matters:** Godot references files by exact path. A file named `Aetherling Idle.png` creates a path with spaces that's easy to mistype in code. Consistent naming prevents bugs.

**Numbered variants:** Use zero-padded two-digit numbers: `aetherling-idle-01.png`, `aetherling-idle-02.png`.

## Image Formats

| Format | Use for | Notes |
|--------|---------|-------|
| **PNG** | All sprites, UI elements, backgrounds | Lossless, supports transparency. This is the default. |
| **JPG** | Never | Lossy compression creates artifacts. Godot re-compresses on import anyway. |
| **PSD** | Source files only | If you keep Photoshop/GIMP source files, put them in `assets/sprites/` alongside the PNG. LFS tracks them. |

**Resolution:** Design at 1x for 1080x1920. Godot handles scaling. Don't create @2x or @3x variants — the engine's import system handles device pixel density.

## Audio Formats

| Format | Use for | Notes |
|--------|---------|-------|
| **OGG** (Vorbis) | Music, ambient loops | Godot's preferred compressed format. Good quality at small file sizes. |
| **WAV** | Sound effects | Uncompressed, no decoding overhead. Best for short one-shot sounds. |
| **MP3** | Avoid | Supported but OGG is better in every way for Godot. |

**Music loops:** If a track is meant to loop seamlessly, note this in the commit message or a comment in the dialogue/quest file that references it. Godot can set loop points on import, but someone needs to know it's a loop.

**Volume normalization:** Try to keep audio levels consistent. If a new track is noticeably louder or quieter than existing ones, Dave can adjust in the AudioManager. Flag it in your commit message.

## Font Formats

| Format | Notes |
|--------|-------|
| **TTF** | Standard TrueType. Works everywhere. |
| **OTF** | OpenType. Also works fine in Godot. |

Put fonts in `assets/fonts/`. Reference the licensing — if a font has a license file, include it as `fontname-license.txt` in the same directory.

## What Gets Tracked by LFS

These file types are automatically handled by Git LFS (configured in `.gitattributes`):

- `.png`, `.jpg`, `.jpeg`, `.psd`, `.tga` (images)
- `.ogg`, `.wav`, `.mp3` (audio)
- `.otf`, `.ttf` (fonts)

You don't need to do anything special. Commit and push as normal — Git knows these are large files and handles them differently behind the scenes.

## Before You Commit

Quick checklist for asset files:

- [ ] File name is lowercase with hyphens (no spaces, no underscores)
- [ ] File is in the correct subdirectory under `assets/`
- [ ] Format is correct (PNG for images, OGG for music, WAV for SFX)
- [ ] File isn't enormous without reason (a 50MB PNG for a small icon is a red flag)
- [ ] If it's a new font, the license file is included

## Replacing an Existing Asset

Just overwrite the file with the new version and commit. Git tracks the history — the old version is still accessible if you need to go back.

> "Commit my changes with message 'update aetherling idle sprite — softer fur color'"

Don't rename the file when updating it. The old name is referenced in scene files (`.tscn`) and code. If a rename is needed, tell Dave — he'll update the references.
