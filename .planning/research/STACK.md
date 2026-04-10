# Technology Stack: Lanternkeeper — Emberfall

**Project:** Calm ritual-based mobile companion game with red panda companion
**Researched:** 2026-04-10
**Overall confidence:** HIGH (most decisions validated against official sources and community benchmarks)

---

## Validated Stack (all decisions confirmed)

### Core Engine

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Godot Engine | 4.6.2 (current stable) | Game engine | Best 2D mobile engine. 4.6 released January 2026 with 2D batch rendering up to 7x faster in some scenarios. 4.6.2 is the latest maintenance release. |
| GDScript | Built-in | Scripting | Python-like syntax accelerates learning for Allie. C# has documented launch crashes on Android and reflection crashes on iOS — not a tradeoff, a hard no. |
| Compatibility Renderer (OpenGL) | Built-in | Rendering | Forward+ (Vulkan) crashes on AMD desktop hardware (relevant for development machine testing), adds shader stutter, provides zero benefit for 2D. Confirmed correct for this project. |

**Confidence:** HIGH — Godot 4.6.2 verified via official release page and SourceForge mirror. GDScript-over-C# and Compatibility-over-Forward+ are documented limitations, not preferences.

---

### Display Settings

| Setting | Value | Why |
|---------|-------|-----|
| Base resolution | 1080×1920 | Portrait-first, common mobile reference resolution |
| Stretch mode | `canvas_items` | Scales texture filtering and pixel art correctly; standard for 2D mobile |
| Stretch aspect | **`keep_width`** | **Correction from brainstorm — see below** |
| Orientation | Portrait | Locked — companion game, single-hand use |

**CORRECTION — keep_height vs keep_width:**
The brainstorm specifies `keep_height` but this is wrong for portrait orientation. The Godot documentation and Android developer guidelines both confirm:
- `keep_height` (Hor+) is correct for **landscape** games — widens the view on wider screens
- `keep_width` (Vert+) is correct for **portrait** games — adds vertical space on taller phones (e.g., 19:9, 21:9)

Modern phones (iPhone 15 Pro Max, Samsung Galaxy) have taller aspect ratios than the 9:16 base. `keep_width` ensures content fills the screen vertically rather than letterboxing. **Change this in project.godot before any scene layout work begins.**

**Confidence:** HIGH — confirmed by official Godot multiple resolutions docs and Android game development documentation.

---

### Particles

| Technology | When to Use | When NOT to Use |
|------------|-------------|-----------------|
| CPUParticles2D | Low count (<100/emitter), mobile, Compatibility renderer | High counts (>500), desktop-only |
| GPUParticles2D | High counts, desktop targets | Low mobile particle budgets |

**Validation confirmed:** Community benchmarks (June 2024) measured GPU particles dropping to 13 FPS at spawn=5 due to high base cost, while CPU particles stayed at 35 FPS for small counts. GPU particles only win at scale (500+). For fog wisps, leaf brushing, and ambient sparkles in this game — all low count — CPUParticles2D is correct.

**Note:** A March 2025 Godot issue (104360) documents that instantiating scenes containing *either* particle type is more expensive in 4.4+ compared to 4.3. Mitigation: pre-instantiate particle emitters rather than creating them dynamically during gameplay.

**Confidence:** HIGH — verified with community benchmarks and official issue tracker.

---

### State Persistence

| Use | Class | Format | Why |
|-----|-------|--------|-----|
| Game state (unlocks, progress, emotion history, return count) | `FileAccess.store_var()` | Binary | Native Godot type support (no manual Vector2/Color conversion), compact, protected against code injection by default |
| User settings (audio volume, particle toggle) | `ConfigFile` | INI-like | Human-readable, section-organized, purpose-built for user preferences |

**Validation confirmed:** Official Godot saving games documentation confirms `store_var()` as the primary approach for game state. ConfigFile is the standard for settings. The split between these two is correct and common practice.

**Mobile note:** Save files live at `user://` which maps to the correct sandboxed location on both iOS and Android. No path changes needed for mobile.

**Confidence:** HIGH — confirmed against official Godot documentation.

---

### Dialogue

| Approach | Why Chosen | Why Not Dialogic |
|----------|-----------|-----------------|
| Hand-rolled JSON loader (custom DialogueManager autoload) | Allie edits JSON directly with no GDScript knowledge; minimal overhead; no plugin dependency | Dialogic is a full visual novel engine — overkill for a companion game with linear/randomized dialogue. Plugin version lock, editor overhead, larger footprint. |

**Dialogic assessment:** Dialogic 2 requires Godot 4.3+ and is actively maintained (recent 4.4.x compatibility update). It is excellent for branching RPG dialogue. For this project — ~20-200 lines per region, randomized by emotional state, no branching trees — a custom JSON reader is 30 lines of GDScript and has zero plugin surface area to break on engine upgrades.

**Recommended JSON schema:**
```json
{
  "region": "lantern_clearing",
  "lines": [
    { "emotion": "any", "weight": 1, "text": "The fog feels lighter today." },
    { "emotion": "creative", "weight": 2, "text": "Something new wants to be made." }
  ]
}
```
Weight field allows frequency tuning without code changes — Allie can adjust this directly.

**Confidence:** MEDIUM — custom JSON is validated pattern, Dialogic assessment based on official repo and feature comparison.

---

### Animation

| Technology | Use Case | Why |
|------------|---------|-----|
| `AnimatedSprite2D` | Aetherling idle, reaction frames | Purpose-built for flipbook sprite animation. Simpler mental model. Beginners (Allie co-learning) can reason about frame sequences without timeline editing. |
| `Tween` (built-in) | UI transitions, scene fades, scale pulses | Godot 4's tween system is powerful and GC-friendly. No AnimationPlayer overhead for simple property animations. |
| `AnimationPlayer` | Complex multi-property sequences (if needed) | Reserve for Phase 2+ if Aetherling needs synchronized animation + sound + position changes. Do not default to it. |

**Confidence:** HIGH — confirmed by official Godot 2D sprite animation docs and community consensus.

---

### Audio Architecture

| Component | Implementation | Why |
|-----------|---------------|-----|
| 3 audio buses: Music, SFX, Ambient | Built into AudioServer | Clean separation. Volume controls per-bus. Music bus for crossfade. Ambient bus for looping scene atmosphere. SFX bus for interaction feedback. |
| Music crossfade | `AudioManager` autoload with two `AudioStreamPlayer` nodes + Tween | Industry-standard pattern. Tween volume_db from current to target over fade_time. GDQuest tutorial confirms this as the canonical approach. |
| SFX pooling | Array of `AudioStreamPlayer` nodes in AudioManager | Avoids per-SFX node instantiation. Pool size of 8-16 is sufficient for a calm companion game. |
| Ambient loops | Dedicated `AudioStreamPlayer` on Ambient bus | One per active region. Crossfade on scene transition same as music. |

**Mobile note:** iOS requires audio session configuration for background audio. For a companion game that users will pick up briefly, default foreground-only behavior is correct — no additional configuration needed.

**Confidence:** HIGH — confirmed by official Godot audio streams documentation and GDQuest crossfade tutorial.

---

### Version Control

| Component | Tool | Configuration |
|-----------|------|--------------|
| Text assets (.gd, .tscn, .tres, .json, .md) | Git (standard) | .tscn and .tres are text-based in Godot 4 — normal diffs work correctly |
| Binary assets (.png, .ogg, .wav, .ttf, .otf) | Git LFS | Track by extension: `*.png`, `*.jpg`, `*.ogg`, `*.wav`, `*.mp3`, `*.ttf`, `*.otf` |

**Critical:** Commit .gitattributes before adding any binary files. If LFS is configured after binaries are committed, those files will exist as large blobs in history.

**Recommended .gitattributes additions:**
```
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.jpeg filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.ttf filter=lfs diff=lfs merge=lfs -text
*.otf filter=lfs diff=lfs merge=lfs -text
*.import binary
```

Note: `.import` files are generated by Godot from source assets and are binary. Track them in LFS or add to .gitignore (regeneratable). The community is split — tracking in LFS keeps repo consistent across machines; .gitignoring them requires a reimport step on clone.

**Confidence:** HIGH — confirmed by Godot forum best practices thread and community gists.

---

### Touch Input

| Component | Implementation | Why |
|-----------|---------------|-----|
| Raw events | `InputEventScreenTouch`, `InputEventScreenDrag` | Built-in. No plugin needed for this game's interaction model. |
| Gesture detection | Custom utility script | For swipe-to-clear-fog and leaf-brushing: track touch start position and compute delta on release. Thresholds in project constants. |
| Third-party option | GodotTouchInputManager (GDTIM) | Available on Asset Library if gesture complexity grows. Overkill for Phase 0-3 but viable fallback. |

**Desktop testing:** Enable `Input > Emulate Touch From Mouse` in Project Settings for editor testing. This setting is per-project, not global — set it in project.godot explicitly.

**Confidence:** HIGH — confirmed by official InputEventScreenTouch documentation.

---

### Safe Area Handling

| Concern | Implementation |
|---------|---------------|
| Notch / Dynamic Island (iPhone) | `DisplayServer.get_display_safe_area()` returns a `Rect2i`. Apply as margins to a root `MarginContainer` wrapping all UI. |
| Home indicator bar (iOS) | Same safe area rect covers this. |
| Status bar | Covered by safe area margins. |

**Pattern (GDScript):**
```gdscript
func _ready() -> void:
    var safe_area: Rect2i = DisplayServer.get_display_safe_area()
    var screen_size: Vector2i = DisplayServer.screen_get_size()
    $SafeAreaContainer.add_theme_constant_override("margin_top", safe_area.position.y)
    $SafeAreaContainer.add_theme_constant_override("margin_left", safe_area.position.x)
    $SafeAreaContainer.add_theme_constant_override("margin_bottom", screen_size.y - safe_area.end.y)
    $SafeAreaContainer.add_theme_constant_override("margin_right", screen_size.x - safe_area.end.x)
```

**Note:** `OS.get_window_safe_area()` was removed in Godot 4; use `DisplayServer.get_display_safe_area()` instead. Several forum posts still reference the old API — ignore them.

**Confidence:** MEDIUM — DisplayServer API confirmed in docs; exact method signature verified via forum posts referencing Godot 4. The old OS.get_window_safe_area removal is documented in forum discussions.

---

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

**Critical workflow note:** Godot exports an Xcode project, not a .ipa directly. Xcode handles the final build and upload. Test on real device early — iOS crashes silently in ways Android and simulator do not surface.

**Confidence:** MEDIUM — export process confirmed by official Godot iOS export docs; specific Xcode version requirement for App Store is Apple policy (changes yearly, verify at submission time).

---

## Autoload Architecture

Four autoloads cover all cross-cutting concerns. This is the correct scope — no fifth autoload should be added without strong justification. Autoload proliferation creates hidden global state.

| Autoload | File | Responsibility | Key API |
|----------|------|---------------|---------|
| `GameState` | `autoloads/game_state.gd` | Save/load player state via `store_var()`. Tracks unlocks, return count, last emotion, quest history. | `save()`, `load()`, `get_state()`, `set_value()` |
| `SceneTransition` | `autoloads/scene_transition.tscn` + `.gd` | Fade-to-black between scenes via Tween. Prevents raw `get_tree().change_scene_to_file()` calls in scene scripts. | `transition_to(scene_path)` signal: `transition_finished` |
| `AudioManager` | `autoloads/audio_manager.tscn` + `.gd` | 3-bus layout, music crossfade, SFX pool, ambient loop management. | `play_music(stream)`, `play_sfx(stream)`, `play_ambient(stream)`, `set_bus_volume(bus, db)` |
| `DialogueManager` | `autoloads/dialogue_manager.gd` | Load JSON dialogue files, filter by region/emotion/weight, emit lines. | `load_region(region_name)`, `get_line(emotion)` signal: `line_ready(text)` |

---

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

---

## Installation / Setup Sequence

```bash
# 1. Download Godot 4.6.2 stable (not mono/C# build)
# https://godotengine.org/download

# 2. Configure Git LFS before any files are added
git lfs install
# Add .gitattributes (see LFS section above)

# 3. Verify iOS toolchain
# - Xcode current version installed
# - Apple Developer account active
# - iOS export templates downloaded via Godot editor
```

**Project settings to configure on first open:**
- Display > Window > Size: Width=1080, Height=1920
- Display > Window > Stretch > Mode: `canvas_items`
- Display > Window > Stretch > Aspect: `keep_width` (NOT keep_height)
- Display > Window > Handheld > Orientation: `portrait`
- Rendering > Renderer: `Compatibility`
- Input > Emulate Touch From Mouse: `true`

---

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
