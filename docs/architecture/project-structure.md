# Project Structure

## Directory Layout

```
lanternkeeper/
  autoloads/              # Global singletons (4 autoloads)
    game_state.gd
    scene_transition.tscn + .gd
    audio_manager.tscn + .gd
    dialogue_manager.gd

  scenes/                 # One folder per game region
    lantern_clearing/     # Home — daily return, grounding ritual
    workshop_glade/       # Ideas and creative notes
    fog_valley/           # Reframes being stuck as information
    warm_river/           # Frustration dissolves without fixing
    observatory_balcony/  # Reflect on meaning

  shared/                 # Cross-scene resources
    ui/                   # Dialogue box, emotion picker, quest display
    shaders/              # Fog shader, glow effects
    themes/               # MkDocs theme (main_theme.tres)

  assets/                 # Binary assets (Git LFS tracked)
    sprites/
      aetherling/         # Red panda character sprites
      backgrounds/        # Scene background art
      ui/                 # UI element sprites
    audio/
      music/              # Background music tracks
      sfx/                # Interaction sound effects
      ambient/            # Environmental loops (wind, rain, fire)
    fonts/

  data/                   # Human-edited JSON content
    dialogue/             # One file per region — Allie edits these
    quests/               # Micro-quest definitions by emotion

  docs/                   # This documentation site (MkDocs)
```

## File Naming

- Scene scripts live next to their `.tscn` file with the same name: `lantern_clearing.tscn` + `lantern_clearing.gd`
- `snake_case` for all GDScript files and scene files
- JSON data files named to match their scene: `data/dialogue/lantern_clearing.json`

## Git Strategy

**Regular Git** tracks:

- All `.gd` scripts
- All `.tscn` and `.tres` files (they're text-based, diff well)
- All `.json` data files
- Documentation

**Git LFS** tracks binary assets:

- Images: `.png`, `.jpg`, `.psd`, `.tga`
- Audio: `.ogg`, `.wav`, `.mp3`
- Fonts: `.otf`, `.ttf`

Configure via `.gitattributes` in repo root.

## What Goes Where

| I want to... | Put it in... |
|--------------|-------------|
| Add Aetherling dialogue | `data/dialogue/<region>.json` |
| Add a micro-quest | `data/quests/micro_quests.json` |
| Create a new scene | `scenes/<region_name>/` |
| Add a shared UI component | `shared/ui/` |
| Add a sprite | `assets/sprites/<category>/` |
| Add background music | `assets/audio/music/` |
| Add a sound effect | `assets/audio/sfx/` |
| Write documentation | `docs/` |
