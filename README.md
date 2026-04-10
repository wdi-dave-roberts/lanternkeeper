# Lanternkeeper: Emberfall

A calm, ritual-based companion game built with Godot 4.6+.

The player meets Aetherling, a small red panda who is also a developer. Together they tend a quiet world called Emberfall — not by rushing, but by returning, reflecting, and beginning again.

## Tech Stack

- **Engine:** Godot 4.6+ (GDScript)
- **Renderer:** Compatibility (OpenGL)
- **Target:** iOS (Android post-MVP)
- **Display:** 1080×1920 portrait

## Project Structure

```
autoloads/       # Global singletons (GameState, SceneTransition, AudioManager, DialogueManager)
scenes/          # One folder per game region (lantern_clearing/, workshop_glade/, etc.)
shared/          # Cross-scene UI components, shaders, themes
assets/          # Binary assets — sprites, audio, fonts (Git LFS tracked)
data/            # Human-edited JSON content — dialogue, quests
docs/            # Design documents and brainstorms
```

## Setup

1. Install [Godot 4.6+](https://godotengine.org/download)
2. Install Git LFS: `brew install git-lfs && git lfs install`
3. Clone this repo (LFS will pull binary assets automatically)
4. Open `project.godot` in Godot

## Team

- **Dave** — architecture, implementation
- **Allie** — creative direction, co-developer
