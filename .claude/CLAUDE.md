# Lanternkeeper: Emberfall

## Project Context

Calm, ritual-based mobile companion game built with Godot 4.6+ (GDScript). A bonding/learning project between Dave and Allie (creative director + learning co-developer). The game is a gift for Garrett, a solo indie game dev.

## Technical Decisions

- **Engine:** Godot 4.6+ — mandatory for mobile renderer improvements
- **Language:** GDScript — C# is experimental on mobile, avoid it
- **Renderer:** Compatibility (OpenGL) — Forward+ crashes on AMD, zero 2D benefit
- **Particles:** CPUParticles2D — lower fixed cost than GPU at low counts on mobile
- **Display:** 1080×1920 portrait, canvas_items stretch, keep_height aspect
- **State:** FileAccess.store_var() for game state, ConfigFile for user settings
- **Dialogue:** JSON files in data/dialogue/ — Allie edits these directly
- **Animation:** AnimatedSprite2D for character idles
- **Audio:** 3 buses (Music, SFX, Ambient), crossfade manager autoload
- **VCS:** Git + LFS for binary assets (PNG, OGG, WAV, TTF)

## Architecture

4 autoloads (singletons) cover cross-cutting concerns:
- `GameState` — save/load player state
- `SceneTransition` — fade between scenes
- `AudioManager` — music crossfade, SFX pool, bus management
- `DialogueManager` — JSON dialogue loading and playback

## GDScript Conventions

- Type hints on all variables and function signatures
- "Call down, signal up" — parents call children directly, children emit signals
- snake_case for files, functions, variables; PascalCase for classes; UPPER_SNAKE for constants
- Signals use past tense: `lantern_lit`, `dialogue_finished`
- Private members prefixed with `_`
- Scene scripts live next to their .tscn file, same name

## Project Structure

- `autoloads/` — 4 singleton scripts/scenes
- `scenes/` — one folder per game region (lantern_clearing/, etc.)
- `shared/` — cross-scene UI, shaders, themes
- `assets/` — binary assets (LFS tracked): sprites/, audio/, fonts/
- `data/` — human-edited JSON: dialogue/, quests/
- `docs/` — design docs and brainstorms

## Mobile-First Rules

- Always test touch interactions, not just mouse
- Project Settings > Emulate Touch From Mouse = true for desktop testing
- Safe area handling designed in, not retrofitted
- Test on real iOS hardware — things crash silently on iOS with no debug output
- Particle toggle in settings for older devices

## Content Workflow

Allie edits JSON files in `data/` for dialogue and quest content. No GDScript needed for content changes. Dave handles all .gd and .tscn files.
