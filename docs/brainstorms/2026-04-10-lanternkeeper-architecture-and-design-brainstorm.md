---
date: 2026-04-10
topic: lanternkeeper-architecture-and-design
---

# Lanternkeeper: Emberfall — Architecture & Design Brainstorm

## What We're Building

A ritual-based mobile companion game featuring a red panda named Aetherling. The player performs small tactile rituals (clearing fog, brushing leaves), checks in emotionally, and receives gentle micro-quests to support their creative work. Five ambient scene regions unlock over time. No scores, no streaks, no guilt.

Built as a bonding/learning project between Dave and his daughter Allie. The game is a gift for Garrett, a solo indie game developer working on a game called Atlas.

**Target platform:** iOS first, Android post-MVP (Godot exports to both — no architectural difference)
**Engine:** Godot 4.6+ (GDScript)
**Game genre:** Interactive ambient companion (Monument Valley's calm + Headspace's ritual structure)
**Team:** Dave (architecture, implementation) + Allie (creative direction, learning co-developer)
**Timeline:** Flexible, no fixed target date
**Multiplayer:** No — single-player only

## Resolved Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Engine | Godot 4.6+ | Best 2D mobile engine. 4.6 has transformative mobile renderer improvements (16→70 FPS on budget hardware). |
| Language | GDScript | C# mobile export is officially experimental with launch crashes. GDScript is Python-like, beginner-friendly. |
| Renderer | Compatibility (OpenGL) | Forward+ (Vulkan) crashes on AMD hardware, shader stutter issues, zero benefit for 2D. |
| Particles | CPUParticles2D | Lower fixed cost than GPU particles at low counts (<100/emitter). Mobile-friendly. |
| Display | 1080×1920, portrait | canvas_items stretch mode, keep_height aspect. Design portrait-first for mobile. |
| State persistence | FileAccess.store_var() | Native Godot type support, safe against code injection. ConfigFile for user settings. |
| Dialogue data | JSON files | Non-technical developer can edit directly. No GDScript knowledge needed for content. |
| Character animation | AnimatedSprite2D | Simpler mental model than AnimationPlayer for flipbook-style idles. |
| Audio architecture | 3 buses (Music, SFX, Ambient) | Crossfade manager autoload for scene transitions. |
| Version control | Git + LFS for binaries | .tres/.tscn are text (regular git). PNG/OGG/WAV/TTF tracked via LFS. |
| Mobile-first | Design in from day 1 | Safe areas, resolution scaling, touch input designed from start — not retrofitted. |
| Android | Deferred to post-MVP | Same codebase, different export pipeline. No architectural cost to deferring. |

## Architecture: 4 Autoloads

These singletons cover every cross-cutting concern:

| Autoload | Script | Purpose |
|----------|--------|---------|
| `GameState` | `autoloads/game_state.gd` | Save/load player state (unlocks, progress, return count) |
| `SceneTransition` | `autoloads/scene_transition.tscn` | Fade between scenes via tween |
| `AudioManager` | `autoloads/audio_manager.tscn` | Music crossfade, SFX pool, bus management |
| `DialogueManager` | `autoloads/dialogue_manager.gd` | JSON dialogue loading and playback |

## Project Structure

```
res://
  project.godot
  autoloads/                  # Singleton scripts (4 autoloads)
    game_state.gd
    scene_transition.tscn
    scene_transition.gd
    audio_manager.tscn
    audio_manager.gd
    dialogue_manager.gd
  scenes/                     # One folder per game region
    lantern_clearing/         # Home scene
      lantern_clearing.tscn
      lantern_clearing.gd
    workshop_glade/
    fog_valley/
    warm_river/
    observatory_balcony/
  shared/                     # Cross-scene UI and shaders
    ui/
      dialogue_box.tscn
      dialogue_box.gd
      emotion_picker.tscn
      emotion_picker.gd
      quest_display.tscn
    shaders/
      fog.gdshader
    themes/
      main_theme.tres
  assets/                     # Binary assets (Git LFS tracked)
    sprites/
      aetherling/
      backgrounds/
      ui/
    audio/
      music/
      sfx/
      ambient/
    fonts/
  data/                       # Human-edited content (Allie edits these)
    dialogue/
      lantern_clearing.json
      workshop_glade.json
      fog_valley.json
      warm_river.json
      observatory_balcony.json
    quests/
      micro_quests.json
```

## Phase Structure

### Phase 0: Technical Foundation (Dave — today, solo)

Everything needed before game development begins. No game content, no creative decisions.

**Toolchain:**
- [ ] Install Godot 4.6+ (stable)
- [ ] Verify iOS export templates download
- [ ] Verify Xcode installed, Apple Developer account active
- [ ] Set up repo: .gitignore, .gitattributes (LFS), CLAUDE.md
- [ ] Initialize Godot project with correct display/renderer settings
- [ ] Create project directory scaffold (autoloads/, scenes/, shared/, assets/, data/)

**Architecture scaffold:**
- [ ] GameState autoload — save/load skeleton with store_var()
- [ ] SceneTransition autoload — fade-to-black scene changer
- [ ] AudioManager autoload — 3-bus layout, crossfade skeleton, SFX pool
- [ ] DialogueManager autoload — JSON loader, signal-based line playback
- [ ] Touch input utility — tap/swipe/drag detection with thresholds

**Mobile-first foundations:**
- [ ] Display settings: 1080×1920, portrait, canvas_items stretch, keep_height
- [ ] Compatibility renderer selected
- [ ] Emulate Touch From Mouse enabled (for desktop testing)
- [ ] Test: blank scene builds and runs on iOS device

**Learning resources prepared for Allie:**
- [ ] Bookmark Brackeys' Godot intro tutorials (community-recommended #1 entry point)
- [ ] Bookmark GDQuest tutorials for next-level learning
- [ ] Prepare a "GDScript in 10 minutes" cheat sheet (types, signals, nodes)

**Phase 0 exit criteria:** Blank Godot project with all 4 autoloads registered, correct mobile settings, runs on iOS device, Git repo configured with LFS. Ready for game content.

### Phase 1: Game Design Parameters (Dave + Allie — tomorrow)

All creative and design decisions that shape what gets built. Allie drives, Dave translates.

**Session Design:**
- [ ] Target session length (likely 2-5 minutes)
- [ ] Daily cadence? Multiple sessions/day? Time-aware?
- [ ] Behavior on repeated opens vs. long absence

**Progression & Unlocking:**
- [ ] What unlocks the 5 regions? (return count, emotional variety, time, player choice)
- [ ] Linear vs. player-chosen progression
- [ ] Can you revisit unlocked regions or only the current one?
- [ ] Visual representation of progress

**Aetherling's Character:**
- [ ] Dialogue volume — how many lines? (20? 200?)
- [ ] Dialogue variation axes — region? emotion? return count?
- [ ] How literally does he reference Emberfall as his own project?
- [ ] Allie hand-writes all dialogue (recommended — it's the soul)

**Micro-Quest System:**
- [ ] Quests per emotion (minimum 3-5 per × 4 emotions = 12-20)
- [ ] Randomized rotation vs. fixed
- [ ] Fire-and-forget vs. completion tracking

**Reset Mechanic:**
- [ ] What resets — visual scene only? Check-in too? Progress?
- [ ] Framing: "restart my morning" vs. "begin fresh"

**Art Direction:**
- [ ] Style: pixel art, illustrated, watercolor, low-poly
- [ ] Asset creation: Allie draws? Asset packs? Commissioned?
- [ ] Aetherling's visual design and animation complexity
- [ ] Color palette / mood board per region

**Sound & Music:**
- [ ] Nature sounds, music, or both?
- [ ] Interaction feedback sounds
- [ ] Source: royalty-free libraries, custom, commissioned

**Phase 1 exit criteria:** All design parameter checkboxes answered. Enough definition to structure Phase 2+ build phases. Final act of Phase 1 is to define the build phase roadmap.

### Phase 2+: Game Development (defined after Phase 1)

Build phases will be created based on resolved design parameters. Preliminary shape:

| Phase | Working Title | What Ships |
|-------|--------------|------------|
| 2 | The Clearing | Lantern Clearing scene with art, fog particles, ambient feel |
| 3 | Touch & Feel | Helping Hands mechanic — swipe fog, brush leaves |
| 4 | The Check-In | Emotional check-in UI, 4 states, stored in GameState |
| 5 | Micro-Quests | Quest display based on emotion, fire-and-forget |
| 6 | Aetherling Lives | Red panda sprite with idle animation in the clearing |
| 7 | Aetherling Speaks | Dialogue system with hand-written lines |
| 8 | Regions Unlock | 4 additional scenes, transitions, unlock logic |
| 9 | Reset Mechanic | "Begin again" — visual reset, lantern relighting |
| 10 | Sound & Polish | Ambient audio, interaction sounds, full polish pass |
| 11 | Ship It | iOS App Store submission, Garrett receives the gift |

These will be refined into proper GSD phases after Phase 1 decisions land.

## Game Dev Concepts Dave Needs to Learn

Ordered by when they're needed:

| Concept | What It Is | When Needed |
|---------|-----------|-------------|
| Scene tree / node hierarchy | Everything is a tree of nodes — Godot's core mental model | Phase 0 |
| Autoloads (singletons) | Global scripts/scenes always loaded. Like service layer. | Phase 0 |
| Signals | Godot's event system. "Call down, signal up." | Phase 0 |
| Type-hinted GDScript | Variables and functions with explicit types. Editor catches errors. | Phase 0 |
| CPUParticles2D | Parameterized particle emitters for fog, leaves, sparkles | Phase 2 |
| Tweens | Smooth property animations (fade, slide, scale) | Phase 2 |
| Touch input events | InputEventScreenTouch, InputEventScreenDrag | Phase 3 |
| AnimatedSprite2D | Flipbook animation from sprite sheets | Phase 6 |
| Audio buses | Layered audio routing (Music/SFX/Ambient) | Phase 10 |
| iOS export pipeline | Export templates, Xcode, signing, provisioning | Phase 11 |
| Git LFS | Binary asset management (PNG, OGG, TTF) | Phase 0 |

## Community-Sourced Warnings

From Reddit research (r/godot, r/gamedev):

1. **Do NOT use Forward+ renderer for mobile** — crashes on AMD, shader stutter, zero 2D benefit
2. **Do NOT use C# for mobile** — experimental, launch crashes on Android, reflection crashes on iOS
3. **Do NOT retrofit mobile support** — safe areas, resolution, touch must be designed in from day 1
4. **Test on real iOS hardware early** — things that work on Android crash silently on iOS with no debug output
5. **Godot 4.6 is mandatory for mobile** — renderer improvements are transformative, not incremental
6. **Re-save scenes after Godot upgrades** — 4.6 adds unique IDs to scenes, stale scenes cause messy diffs

## Learning Path for Allie

1. **Brackeys' Godot intro tutorials** (YouTube) — community #1 recommendation for beginners
2. **GDQuest 2-hour tutorials** — hands-on building after basics
3. **Editing JSON dialogue files** — immediate contribution without GDScript
4. **GDScript basics** — variables, functions, signals, the scene tree
5. **20 Game Challenge** (optional) — build tiny games independently to cement skills

## Next Steps

→ Execute Phase 0 today (Dave solo)
→ Execute Phase 1 tomorrow (Dave + Allie)
→ `/gsd-new-project` after Phase 1 to formalize the build roadmap
