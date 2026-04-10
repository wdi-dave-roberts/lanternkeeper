<!-- GSD:project-start source:PROJECT.md -->
## Project

**Lanternkeeper: Emberfall**

A calm, ritual-based mobile companion game featuring a red panda named Aetherling. The player performs small tactile rituals (clearing fog, brushing leaves), checks in emotionally, and receives gentle micro-quests to support their creative work. Five ambient scene regions unlock over time. No scores, no streaks, no guilt. Built with Godot 4.6+ (GDScript), targeting iOS first.

This is a bonding/learning project between Dave and his daughter Allie (creative director + learning co-developer). The game is a gift for Garrett, a solo indie game dev working on Atlas.

**Core Value:** Gentle, guilt-free creative companionship — the player feels cared for without pressure. The rituals and Aetherling's presence create a moment of calm that supports the player's real-world creative work.

### Constraints

- **Engine version**: Godot 4.6+ mandatory — mobile renderer improvements are transformative (16 to 70 FPS on budget hardware)
- **Language**: GDScript only — C# is experimental on mobile with launch crashes
- **Renderer**: Compatibility (OpenGL) — Forward+ crashes on AMD, zero 2D benefit
- **Display**: 1080x1920 portrait, canvas_items stretch, keep_height aspect
- **Mobile-first**: Safe areas, resolution scaling, touch input designed from start — not retrofitted
- **iOS testing**: Must test on real hardware early — things crash silently on iOS with no debug output
- **Scene upgrades**: Re-save scenes after Godot upgrades — 4.6 adds unique IDs, stale scenes cause messy diffs
<!-- GSD:project-end -->

<!-- GSD:stack-start source:research/STACK.md -->
## Technology Stack

## Validated Stack (all decisions confirmed)
### Core Engine
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Godot Engine | 4.6.2 (current stable) | Game engine | Best 2D mobile engine. 4.6 released January 2026 with 2D batch rendering up to 7x faster in some scenarios. 4.6.2 is the latest maintenance release. |
| GDScript | Built-in | Scripting | Python-like syntax accelerates learning for Allie. C# has documented launch crashes on Android and reflection crashes on iOS — not a tradeoff, a hard no. |
| Compatibility Renderer (OpenGL) | Built-in | Rendering | Forward+ (Vulkan) crashes on AMD desktop hardware (relevant for development machine testing), adds shader stutter, provides zero benefit for 2D. Confirmed correct for this project. |
### Display Settings
| Setting | Value | Why |
|---------|-------|-----|
| Base resolution | 1080×1920 | Portrait-first, common mobile reference resolution |
| Stretch mode | `canvas_items` | Scales texture filtering and pixel art correctly; standard for 2D mobile |
| Stretch aspect | **`keep_width`** | **Correction from brainstorm — see below** |
| Orientation | Portrait | Locked — companion game, single-hand use |
- `keep_height` (Hor+) is correct for **landscape** games — widens the view on wider screens
- `keep_width` (Vert+) is correct for **portrait** games — adds vertical space on taller phones (e.g., 19:9, 21:9)
### Particles
| Technology | When to Use | When NOT to Use |
|------------|-------------|-----------------|
| CPUParticles2D | Low count (<100/emitter), mobile, Compatibility renderer | High counts (>500), desktop-only |
| GPUParticles2D | High counts, desktop targets | Low mobile particle budgets |
### State Persistence
| Use | Class | Format | Why |
|-----|-------|--------|-----|
| Game state (unlocks, progress, emotion history, return count) | `FileAccess.store_var()` | Binary | Native Godot type support (no manual Vector2/Color conversion), compact, protected against code injection by default |
| User settings (audio volume, particle toggle) | `ConfigFile` | INI-like | Human-readable, section-organized, purpose-built for user preferences |
### Dialogue
| Approach | Why Chosen | Why Not Dialogic |
|----------|-----------|-----------------|
| Hand-rolled JSON loader (custom DialogueManager autoload) | Allie edits JSON directly with no GDScript knowledge; minimal overhead; no plugin dependency | Dialogic is a full visual novel engine — overkill for a companion game with linear/randomized dialogue. Plugin version lock, editor overhead, larger footprint. |
### Animation
| Technology | Use Case | Why |
|------------|---------|-----|
| `AnimatedSprite2D` | Aetherling idle, reaction frames | Purpose-built for flipbook sprite animation. Simpler mental model. Beginners (Allie co-learning) can reason about frame sequences without timeline editing. |
| `Tween` (built-in) | UI transitions, scene fades, scale pulses | Godot 4's tween system is powerful and GC-friendly. No AnimationPlayer overhead for simple property animations. |
| `AnimationPlayer` | Complex multi-property sequences (if needed) | Reserve for Phase 2+ if Aetherling needs synchronized animation + sound + position changes. Do not default to it. |
### Audio Architecture
| Component | Implementation | Why |
|-----------|---------------|-----|
| 3 audio buses: Music, SFX, Ambient | Built into AudioServer | Clean separation. Volume controls per-bus. Music bus for crossfade. Ambient bus for looping scene atmosphere. SFX bus for interaction feedback. |
| Music crossfade | `AudioManager` autoload with two `AudioStreamPlayer` nodes + Tween | Industry-standard pattern. Tween volume_db from current to target over fade_time. GDQuest tutorial confirms this as the canonical approach. |
| SFX pooling | Array of `AudioStreamPlayer` nodes in AudioManager | Avoids per-SFX node instantiation. Pool size of 8-16 is sufficient for a calm companion game. |
| Ambient loops | Dedicated `AudioStreamPlayer` on Ambient bus | One per active region. Crossfade on scene transition same as music. |
### Version Control
| Component | Tool | Configuration |
|-----------|------|--------------|
| Text assets (.gd, .tscn, .tres, .json, .md) | Git (standard) | .tscn and .tres are text-based in Godot 4 — normal diffs work correctly |
| Binary assets (.png, .ogg, .wav, .ttf, .otf) | Git LFS | Track by extension: `*.png`, `*.jpg`, `*.ogg`, `*.wav`, `*.mp3`, `*.ttf`, `*.otf` |
### Touch Input
| Component | Implementation | Why |
|-----------|---------------|-----|
| Raw events | `InputEventScreenTouch`, `InputEventScreenDrag` | Built-in. No plugin needed for this game's interaction model. |
| Gesture detection | Custom utility script | For swipe-to-clear-fog and leaf-brushing: track touch start position and compute delta on release. Thresholds in project constants. |
| Third-party option | GodotTouchInputManager (GDTIM) | Available on Asset Library if gesture complexity grows. Overkill for Phase 0-3 but viable fallback. |
### Safe Area Handling
| Concern | Implementation |
|---------|---------------|
| Notch / Dynamic Island (iPhone) | `DisplayServer.get_display_safe_area()` returns a `Rect2i`. Apply as margins to a root `MarginContainer` wrapping all UI. |
| Home indicator bar (iOS) | Same safe area rect covers this. |
| Status bar | Covered by safe area margins. |
### iOS Export Pipeline
| Requirement | Detail |
|-------------|--------|
| Build OS | macOS only — Godot iOS export requires Xcode, which runs only on macOS |
| Xcode | Current version required by App Store (Xcode 16.x as of early 2026) |
| Apple Developer Account | Required for device signing and App Store distribution ($99/year) |
| Export templates | Download via Godot Editor > Export > Manage Export Templates |
| Signing | Godot generates an .xcodeproj; open in Xcode to handle signing, provisioning profiles, and App Store upload |
| Team ID | 10-character code (e.g., ABCDE12XYZ) — required field in Godot export settings |
| Bundle ID | Reverse-domain format (e.g., com.yourdomain.lanternkeeper) — required field |
## Autoload Architecture
| Autoload | File | Responsibility | Key API |
|----------|------|---------------|---------|
| `GameState` | `autoloads/game_state.gd` | Save/load player state via `store_var()`. Tracks unlocks, return count, last emotion, quest history. | `save()`, `load()`, `get_state()`, `set_value()` |
| `SceneTransition` | `autoloads/scene_transition.tscn` + `.gd` | Fade-to-black between scenes via Tween. Prevents raw `get_tree().change_scene_to_file()` calls in scene scripts. | `transition_to(scene_path)` signal: `transition_finished` |
| `AudioManager` | `autoloads/audio_manager.tscn` + `.gd` | 3-bus layout, music crossfade, SFX pool, ambient loop management. | `play_music(stream)`, `play_sfx(stream)`, `play_ambient(stream)`, `set_bus_volume(bus, db)` |
| `DialogueManager` | `autoloads/dialogue_manager.gd` | Load JSON dialogue files, filter by region/emotion/weight, emit lines. | `load_region(region_name)`, `get_line(emotion)` signal: `line_ready(text)` |
## What NOT to Use
| Avoid | Reason |
|-------|--------|
| C# scripting | Launch crashes on Android, reflection crashes on iOS — not theoretical, documented |
| Forward+ / Mobile renderer | Forward+ crashes AMD desktop hardware; Mobile renderer (not Compatibility) is an intermediate choice that also has overhead. Use Compatibility (OpenGL). |
| GPUParticles2D for small counts | Higher base cost than CPU at <100 particles; measured drop to 13 FPS at 5 particles on Compatibility renderer |
| Dialogic plugin | Overkill for this dialogue volume. Plugin version lock is a maintenance burden. |
| AnimationPlayer as default | Reserve for complex multi-property timelines. Default to AnimatedSprite2D + Tween. |
| `OS.get_window_safe_area()` | Removed in Godot 4. Use `DisplayServer.get_display_safe_area()`. |
| `keep_height` aspect for portrait | Wrong setting. Use `keep_width` for portrait orientation. |
## Installation / Setup Sequence
# 1. Download Godot 4.6.2 stable (not mono/C# build)
# https://godotengine.org/download
# 2. Configure Git LFS before any files are added
# Add .gitattributes (see LFS section above)
# 3. Verify iOS toolchain
# - Xcode current version installed
# - Apple Developer account active
# - iOS export templates downloaded via Godot editor
- Display > Window > Size: Width=1080, Height=1920
- Display > Window > Stretch > Mode: `canvas_items`
- Display > Window > Stretch > Aspect: `keep_width` (NOT keep_height)
- Display > Window > Handheld > Orientation: `portrait`
- Rendering > Renderer: `Compatibility`
- Input > Emulate Touch From Mouse: `true`
## Sources
- Godot 4.6 Release Page: https://godotengine.org/releases/4.6/
- Godot 4.6.2 stable release: https://sourceforge.net/projects/godot-engine.mirror/files/4.6.2-stable/
- CPU vs GPU Particles performance benchmark (community, June 2024): https://forum.godotengine.org/t/cpu-vs-gpu-particles-2d-performance-study-careful-gpu-particles-seem-to-have-a-high-base-cost/67850
- Godot saving games (official docs): https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
- GDQuest save system cheat sheet: https://www.gdquest.com/library/cheatsheet_save_systems/
- GDQuest crossfade music tutorial: https://www.gdquest.com/tutorial/godot/audio/background-music-transition/
- iOS export (official docs): https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
- Multiple resolutions (official docs): https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
- Android portrait keep_width recommendation: https://developer.android.com/games/engines/godot/godot-formfactor
- Safe area / notch handling: https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971
- AnimatedSprite2D vs AnimationPlayer: https://uhiyama-lab.com/en/notes/godot/animatedsprite2d-vs-animationplayer-comparison/
- Dialogic GitHub: https://github.com/dialogic-godot/dialogic
- Nathan Hoad Dialogue Manager (Godot 4.6+): https://github.com/nathanhoad/godot_dialogue_manager
- Git LFS best practices for Godot: https://forum.godotengine.org/t/best-practices-for-setting-up-git-lfs/75357
- CPUParticles2D instantiation issue (Godot 4.4+): https://github.com/godotengine/godot/issues/104360
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:skills-start source:skills/ -->
## Project Skills

No project skills found. Add skills to any of: `.claude/skills/`, `.agents/skills/`, `.cursor/skills/`, or `.github/skills/` with a `SKILL.md` index file.
<!-- GSD:skills-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
