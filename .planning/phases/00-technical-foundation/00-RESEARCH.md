# Phase 0: Technical Foundation - Research

**Researched:** 2026-04-10
**Domain:** Godot 4.6 project initialization, iOS export pipeline, GDScript autoload architecture
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-01:** Godot orientation folded into Phase 0. Claude explains each concept (scenes, nodes, scripts, signals, autoloads) in plain language as it becomes relevant. Install Godot is naturally the first step.
- **D-02:** Autoloads in Phase 0 are functional stubs — not bare structure, not full implementation. Each service does its core job with placeholder content: GameState saves/loads, SceneTransition fades, AudioManager plays on correct bus, DialogueManager loads JSON. Enough to verify on iOS.
- **D-03:** Apple Developer Program enrollment is a prerequisite blocker — Dave does not currently have an active membership. Must sign up ($99/year) before iOS build verification can happen.
- **D-04:** iOS test scene must show something on screen — a colored background and "Lanternkeeper" label. Not just a blank screen.
- **D-05:** iOS builds on Dave's MacBook or Mac Mini. Allie is PC only — cannot do iOS builds.
- **D-06:** iOS minimum deployment target = 16.0, set manually in Xcode after every export.
- **D-07:** Learning resources are markdown docs in the repo served via the docs site (https://wdi-dave-roberts.github.io/lanternkeeper/). Not browser bookmarks, not Google Docs.
- **D-08:** Phase 0-1 are Dave solo. Allie joins Phase 1 for design decisions. She is not hands-on in tools during Phase 0.
- **D-09:** Allie is 32, technically curious, exploring a potential career change. Learning resources should be curated and approachable, not overwhelming.
- **D-10:** Godot editor creates the project (generates project.godot). Do not hand-write project.godot. After creation, verify and adjust the 5-6 key settings.
- **D-11:** Docs site must be updated as work progresses — not as an afterthought. Platform differences (e.g., installing Godot) require both Mac and PC instructions.
- **D-12:** `keep_width` stretch aspect for portrait orientation (research correction from brainstorm).
- **D-13:** Git LFS must be committed before any binary asset enters history (.gitattributes already configured).

### Claude's Discretion

- Autoload initialization order (GameState first, then AudioManager, SceneTransition, DialogueManager — or adjust based on dependency analysis)
- Test scene structure for iOS verification (node hierarchy, exact layout)
- GDScript cheat sheet content and tutorial curation for Allie's learning docs

### Deferred Ideas (OUT OF SCOPE)

- ~~Phase 0.1: Orientation~~ — Folded into Phase 0
- **Allie's PC development environment** — Not relevant for Phase 0; will get its own attention when she starts hands-on work post Phase 1
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| FOUND-01 | Godot 4.6+ project initialized: Compatibility renderer, 1080x1920 portrait, canvas_items stretch, `keep_width` aspect | Project Settings fields documented; `keep_width` verified as correct for portrait |
| FOUND-02 | 4 autoloads registered in correct order: GameState, AudioManager, SceneTransition, DialogueManager — each with skeleton implementation | Autoload order is top-to-bottom in Project Settings; dependency analysis in Architecture section |
| FOUND-03 | GameState saves/loads via FileAccess.store_var() with `schema_version: 1` key and `.get("key", default)` pattern | FileAccess.store_var() / get_var() confirmed as canonical pattern; code example provided |
| FOUND-04 | SceneTransition fades via tween on a persistent CanvasLayer (overlay on autoload, not scenes) | Tween property animation pattern confirmed; CanvasLayer-in-autoload is standard Godot approach |
| FOUND-05 | AudioManager has 3-bus layout (Music, SFX, Ambient) with crossfade skeleton and SFX pool | Crossfade pattern confirmed; critical pitfall found (tween in autoload requires bind_node) |
| FOUND-06 | DialogueManager loads JSON from data/dialogue/, emits signals for line playback | JSON + signals pattern is straightforward GDScript; no special library needed |
| FOUND-07 | Touch utility detects tap, swipe, drag with configurable thresholds using InputEventScreenTouch/Drag | Built-in events confirmed; custom threshold script is appropriate; GDTIM available as fallback |
| FOUND-08 | Git LFS configured via .gitattributes for PNG, OGG, WAV, TTF — committed before binary assets | VERIFIED: .gitattributes already exists and covers all required types plus extras |
| FOUND-09 | Project directory scaffold created | VERIFIED: All directories exist (autoloads/, scenes/, shared/, assets/, data/dialogue/, data/quests/) |
| FOUND-10 | Emulate Touch From Mouse enabled | Project Settings path documented; single toggle |
| FOUND-11 | Blank project builds, exports, runs on physical iOS device — full pipeline verified | Pipeline steps documented; BLOCKER: Apple Developer enrollment required; Xcode.app not installed |
| FOUND-12 | Safe area MarginContainer pattern using DisplayServer.get_display_safe_area() | Verified implementation code found; pattern documented |
| FOUND-13 | Learning resources for Allie: Brackeys Godot intro, GDQuest, GDScript cheat sheet | Existing docs at docs/learning/ partially cover this; cheat sheet content already in gdscript-basics.md |
</phase_requirements>

---

## Summary

Phase 0 is the technical bedrock: initialize a Godot 4.6 project with the correct display/renderer settings, scaffold four functional-stub autoloads, verify the iOS build pipeline end-to-end on real hardware, and prepare Allie's learning docs. All technology decisions are already locked in CLAUDE.md — this research validates those decisions and surfaces the specific pitfalls and patterns the planner needs.

The biggest external blocker is the iOS pipeline: Xcode.app is not installed on this machine (only Command Line Tools), and Apple Developer Program enrollment is pending (D-03). These are sequential gates — enrollment first, then Xcode install, then export template download, then test build. The planner must sequence these as early waves so nothing is blocked.

A critical Godot-specific pitfall: tweening AudioStreamPlayer volume from an autoload scene requires `bind_node()` + `tween_method()`, not direct property tweening. Direct property tweening in an autoload context breaks all audio until the tween completes. This affects the AudioManager crossfade implementation and must be in every AudioManager code example.

**Primary recommendation:** Sequence the phase so Apple Developer enrollment and Xcode install are Wave 0 prerequisite tasks. All four autoloads can be scaffolded in parallel while waiting for enrollment to process. iOS build verification is the final gate.

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Godot 4.6.2 | All FOUND requirements | ✗ | Not installed | Must install — download from godotengine.org |
| Xcode.app | FOUND-11 (iOS export) | ✗ | CLT only (no Xcode.app) | Must install Xcode from App Store |
| Apple Developer Account | FOUND-11 | ✗ | Not enrolled (D-03) | Must enroll at developer.apple.com ($99/year) |
| Git LFS | FOUND-08 | ✓ | 3.7.1 | — |
| MkDocs site config | FOUND-13 | ✓ | mkdocs.yml present | — |
| autoloads/ scaffold | FOUND-02 through FOUND-07 | ✓ | Empty dir exists | — |
| scenes/ scaffold | FOUND-09 | ✓ | 5 region dirs present | — |
| .gitattributes (LFS) | FOUND-08 | ✓ | Configured for PNG, OGG, WAV, TTF, OTF, JPG, MP3, PSD, TGA | — |

**Missing dependencies with no fallback:**
- Godot 4.6.2 — must be installed before any project work begins. Download the standard (non-.NET) build from https://godotengine.org/download. On macOS: drag to Applications. No installer — single executable. [VERIFIED: godotengine.org]
- Xcode.app — iOS export requires Xcode.app (not just Command Line Tools). Install from the Mac App Store. Currently, Xcode 16 is required for App Store builds; Xcode 16 is sufficient for device testing.
- Apple Developer Program — $99/year enrollment required before signing or device install. Enrollment takes up to 48 hours to process.

**Time-sensitive note (April 2026):** Apple's App Store submission requirement changes on April 28, 2026 — iOS and iPadOS apps will need to be built with the iOS 26 SDK (requiring Xcode 26). Phase 0 iOS verification is device-testing only (not App Store submission), so Xcode 16 is sufficient for this phase. However, the planner should note that App Store submission (future phase) will require Xcode 26. [CITED: developer.apple.com/news/upcoming-requirements/]

---

## Standard Stack

### Core
| Technology | Version | Purpose | Why Standard |
|------------|---------|---------|--------------|
| Godot Engine | 4.6.2 stable | Game engine | Locked in CLAUDE.md; latest maintenance release |
| GDScript | Built-in | All scripting | Locked in CLAUDE.md; C# has documented iOS crashes |
| Compatibility Renderer (OpenGL) | Built-in | Rendering | Locked in CLAUDE.md; Forward+ crashes AMD |
| CPUParticles2D | Built-in | Particles (future phases) | Lower fixed cost at <100 particles on mobile |

### Display Settings (all locked, verified in CLAUDE.md)
| Setting | Value | Why |
|---------|-------|-----|
| Base resolution | 1080×1920 | Portrait-first, common mobile reference |
| Stretch mode | `canvas_items` | Correct for 2D mobile |
| Stretch aspect | `keep_width` | Correct for portrait — adds vertical space on taller phones |
| Orientation | Portrait locked | Single-hand companion game |
| Renderer | Compatibility | Locked |

### Supporting Libraries
| Library | Purpose | When to Use |
|---------|---------|-------------|
| GodotTouchInputManager (GDTIM) | Extended gesture detection | If custom touch utility is insufficient in later phases |

### What NOT to Install
| Avoid | Reason |
|-------|--------|
| Godot .NET / C# build | iOS launch crashes |
| Dialogic plugin | Overkill for this dialogue volume; adds version lock |
| Any animation library | Tween + AnimatedSprite2D covers all Phase 0 needs |

**Installation:** Download Godot 4.6.2 standard (not mono) from https://godotengine.org/download. On macOS: drag to Applications. No installer — single executable. [VERIFIED: godotengine.org]

---

## Architecture Patterns

### Autoload Initialization Order

Autoloads in Godot 4 initialize in the order they appear in Project Settings > Autoload (top-to-bottom). [CITED: docs.godotengine.org/en/4.6/tutorials/scripting/singletons_autoload.html]

**Recommended order and rationale:**

1. **GameState** — No dependencies; everything else may read state on init
2. **AudioManager** — Depends on nothing; SceneTransition may trigger audio during first fade
3. **SceneTransition** — May use AudioManager for audio on transitions; must be ready before first scene loads
4. **DialogueManager** — Depends only on file system; loads lazily when a region is requested

**Critical rule:** Never call another autoload from `_init()`. Use `_ready()` or `_enter_tree()` — other autoloads are not guaranteed to exist yet during `_init()`. [CITED: Godot forum, community-verified]

### GameState Autoload Pattern

```gdscript
# autoloads/game_state.gd
extends Node

const SAVE_PATH := "user://gamestate.dat"
const SCHEMA_VERSION := 1

var _state: Dictionary = {}

func _ready() -> void:
    load_state()

func load_state() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        _state = _default_state()
        return
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file:
        _state = file.get_var(true)
        if _state.get("schema_version", 0) != SCHEMA_VERSION:
            _state = _default_state()

func save_state() -> void:
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_var(_state, true)

func get_value(key: String, default: Variant = null) -> Variant:
    return _state.get(key, default)

func set_value(key: String, value: Variant) -> void:
    _state[key] = value
    save_state()

func _default_state() -> Dictionary:
    return {
        "schema_version": SCHEMA_VERSION,
        "unlocked_scenes": ["lantern_clearing"],
        "return_count": 0,
        "last_emotion": "",
    }
```

Note: `store_var(data, true)` — the second argument enables full object serialization. `get_var(true)` on the read side. [CITED: docs.godotengine.org/en/stable/classes/class_fileaccess.html]

### SceneTransition Autoload Pattern

SceneTransition must be a `.tscn` + `.gd` pair (not a bare script) because it contains nodes (CanvasLayer > ColorRect for the overlay). The overlay lives on the autoload, not on individual scenes.

```gdscript
# autoloads/scene_transition.gd
extends CanvasLayer

signal transition_finished

@onready var _overlay: ColorRect = $ColorRect

func _ready() -> void:
    _overlay.color = Color.BLACK
    _overlay.modulate.a = 0.0

func transition_to(scene_path: String) -> void:
    var tween := create_tween()
    tween.tween_property(_overlay, "modulate:a", 1.0, 0.4)
    await tween.finished
    get_tree().change_scene_to_file(scene_path)
    tween = create_tween()
    tween.tween_property(_overlay, "modulate:a", 0.0, 0.4)
    await tween.finished
    transition_finished.emit()
```

Scene structure: `SceneTransition (CanvasLayer, layer=128) > ColorRect (full-screen, anchored to fill)`

### AudioManager Autoload Pattern — CRITICAL PITFALL

**Pitfall:** Tweening `volume_db` directly on an AudioStreamPlayer that is in an autoload scene causes all audio to break until the tween completes. This is a documented Godot forum issue. [CITED: forum.godotengine.org/t/cannot-tween-audiostreamplayers-in-autoload-scene/49884]

**Fix:** Use `bind_node()` + `tween_method()` instead of `tween_property()`:

```gdscript
# CORRECT — use this pattern for crossfade in autoload
func _crossfade_to(new_stream: AudioStream) -> void:
    _player_b.stream = new_stream
    _player_b.play()
    var tween := create_tween().bind_node(_player_a)
    tween.tween_method(_set_player_a_volume, 1.0, 0.0, CROSSFADE_TIME)
    await tween.finished
    _player_a.stop()
    # swap A and B references

func _set_player_a_volume(value: float) -> void:
    _player_a.volume_db = linear_to_db(value)
```

AudioManager scene structure: Three `AudioStreamPlayer` nodes for music crossfade (player_a, player_b) + SFX pool (array of 8 players) — all on the Ambient, Music, and SFX buses respectively. Audio buses must be created in the Audio bus layout editor first (not in code).

### DialogueManager Autoload Pattern

```gdscript
# autoloads/dialogue_manager.gd
extends Node

signal line_ready(text: String)

var _lines: Array[Dictionary] = []
var _current_index: int = 0

func load_region(region_name: String) -> void:
    var path := "res://data/dialogue/%s.json" % region_name
    if not FileAccess.file_exists(path):
        push_warning("DialogueManager: no dialogue file for region: %s" % region_name)
        return
    var file := FileAccess.open(path, FileAccess.READ)
    var json := JSON.new()
    json.parse(file.get_as_text())
    _lines = json.data
    _current_index = 0

func get_line(emotion: String) -> void:
    # Filter lines matching emotion, pick by weight, emit signal
    var candidates := _lines.filter(func(l): return l.get("emotion", "") == emotion)
    if candidates.is_empty():
        candidates = _lines  # fallback: any line
    var picked: Dictionary = candidates[randi() % candidates.size()]
    line_ready.emit(picked.get("text", ""))
```

### Touch Input Utility Pattern

```gdscript
# shared/touch_input.gd
extends Node

signal tapped(position: Vector2)
signal swiped(direction: Vector2)
signal dragged(delta: Vector2)

const TAP_MAX_DURATION := 0.3       # seconds
const SWIPE_MIN_DISTANCE := 50.0    # pixels

var _touch_start_pos: Vector2
var _touch_start_time: float

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            _touch_start_pos = event.position
            _touch_start_time = Time.get_ticks_msec() / 1000.0
        else:
            var duration := (Time.get_ticks_msec() / 1000.0) - _touch_start_time
            var delta := event.position - _touch_start_pos
            if duration < TAP_MAX_DURATION and delta.length() < SWIPE_MIN_DISTANCE:
                tapped.emit(event.position)
            elif delta.length() >= SWIPE_MIN_DISTANCE:
                swiped.emit(delta.normalized())
    elif event is InputEventScreenDrag:
        dragged.emit(event.relative)
```

This utility is registered as a 5th autoload (or as a shared script attached to the main scene). CLAUDE.md notes it as FOUND-07.

### Safe Area MarginContainer Pattern

```gdscript
# shared/ui/safe_area_container.gd
extends MarginContainer

func _ready() -> void:
    var os := OS.get_name()
    if os == "iOS" or os == "Android":
        _apply_safe_area()

func _apply_safe_area() -> void:
    var screen_safe_rect := Rect2(DisplayServer.get_display_safe_area())
    var viewport_transform := get_viewport().get_final_transform()
    var viewport_safe_rect := screen_safe_rect * viewport_transform.affine_inverse()
    var viewport_full_rect := get_viewport().get_visible_rect()
    var left := viewport_safe_rect.position.x - viewport_full_rect.position.x
    var top := viewport_safe_rect.position.y - viewport_full_rect.position.y
    var right := viewport_full_rect.end.x - viewport_safe_rect.end.x
    var bottom := viewport_full_rect.end.y - viewport_safe_rect.end.y
    begin_bulk_theme_override()
    add_theme_constant_override("margin_left", roundi(left))
    add_theme_constant_override("margin_top", roundi(top))
    add_theme_constant_override("margin_right", roundi(right))
    add_theme_constant_override("margin_bottom", roundi(bottom))
    end_bulk_theme_override()
```

[CITED: forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971]

This `SafeAreaContainer` wraps all UI in the root scene. The pattern is: `root scene > SafeAreaContainer (full screen) > [all UI nodes]`.

### Project Settings Changes After Editor Creates project.godot

Godot editor creates `project.godot` — do not edit it by hand. After creation, adjust these settings:

| Setting Path | Value |
|---|---|
| Display > Window > Size > Viewport Width | 1080 |
| Display > Window > Size > Viewport Height | 1920 |
| Display > Window > Stretch > Mode | `canvas_items` |
| Display > Window > Stretch > Aspect | `keep_width` |
| Display > Window > Handheld > Orientation | `portrait` |
| Rendering > Renderer > Rendering Method | `gl_compatibility` |
| Input Devices > Pointing > Emulate Touch From Mouse | `true` |

### iOS Export Pipeline Steps

1. **Prerequisite (external):** Enroll in Apple Developer Program at developer.apple.com ($99/year, up to 48h processing)
2. **Install Xcode.app** from Mac App Store (currently Xcode 16.x required) — not just Command Line Tools
3. **Download Godot iOS export templates** via Editor > Manage Export Templates
4. **Create export preset** in Project > Export > Add > iOS
   - Set Bundle ID (reverse-domain: `com.yourname.lanternkeeper`)
   - Set Team ID (10-char code from developer.apple.com)
   - Set minimum iOS deployment: **16.0** (set in Xcode after export, not in Godot)
5. **Export to .xcodeproj** (not direct .ipa — Godot generates an Xcode project)
6. **Open in Xcode**, configure signing, provisioning profile, deployment target (16.0)
7. **Build and run** on physical device via Xcode
8. **Project name must not contain spaces** — Xcode will corrupt the project

**Apple Developer enrollment note (D-03):** This is a blocking prerequisite. The plan must treat enrollment as Wave 0 with a 48-hour wait state before any iOS build steps can execute.

### Recommended Project Structure

```
autoloads/
├── game_state.gd
├── audio_manager.gd + audio_manager.tscn
├── scene_transition.gd + scene_transition.tscn
└── dialogue_manager.gd
scenes/
├── main/                    # test scene for iOS verification
│   └── main.tscn + main.gd
├── lantern_clearing/
├── fog_valley/
├── observatory_balcony/
├── warm_river/
└── workshop_glade/
shared/
├── ui/
│   └── safe_area_container.gd
├── touch_input.gd
├── shaders/
└── themes/
assets/
├── sprites/
├── audio/
└── fonts/
data/
├── dialogue/
└── quests/
docs/
└── learning/
    ├── getting-started.md     (exists, partially populated)
    ├── gdscript-basics.md     (exists, well-populated)
    └── gsd-guide.md           (exists)
```

### Anti-Patterns to Avoid

- **Hand-writing project.godot:** Internal format is version-specific and Godot regenerates it. Use the editor (D-10).
- **Calling autoloads from `_init()`:** Other autoloads may not exist yet. Use `_ready()`.
- **Direct `tween_property()` on AudioStreamPlayer in autoload:** Breaks all audio. Use `bind_node()` + `tween_method()`.
- **`OS.get_window_safe_area()`:** Removed in Godot 4. Use `DisplayServer.get_display_safe_area()`.
- **`keep_height` for portrait:** Wrong. Use `keep_width` for portrait orientation (D-12).
- **Spaces in project export name:** Corrupts Xcode project.
- **GPUParticles2D for low counts:** Measured drop to 13 FPS at 5 particles on Compatibility renderer (Phase 0 note — relevant for Phase 2+).

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Save file binary serialization | Custom encoder | `FileAccess.store_var()` / `get_var()` | Native Godot type support (Vector2, Color, etc.), compact, injection-safe |
| JSON parsing | Custom parser | `JSON.new().parse()` built-in | GDScript built-in, handles all standard JSON |
| Scene fading | Manual alpha tweens in each scene | `SceneTransition` autoload with CanvasLayer overlay | Keeps scenes clean; no per-scene fade logic |
| Audio bus management | Per-scene volume code | `AudioManager` autoload | Consistent bus volumes, pooled players |
| Safe area insets | Hard-coded padding | `DisplayServer.get_display_safe_area()` + MarginContainer | Works across all iOS device shapes |
| Gesture detection | State machine tracking touch events | Built-in `InputEventScreenTouch` + `InputEventScreenDrag` | Sufficient for this game's needs; GDTIM fallback if needed |

---

## Common Pitfalls

### Pitfall 1: Tween in Autoload Breaks Audio
**What goes wrong:** Using `tween.tween_property(audio_player, "volume_db", ...)` on a player inside an autoload scene breaks all audio output until the tween completes.
**Why it happens:** Tweens in autoloads have a different lifecycle than tweens in scene trees. The property tween runs but invalidates the audio graph.
**How to avoid:** Always use `create_tween().bind_node(player)` + `tween_method()` for volume fades in AudioManager. [CITED: forum.godotengine.org/t/cannot-tween-audiostreamplayers-in-autoload-scene/49884]
**Warning signs:** Volume change works but all other sounds cut out during the fade.

### Pitfall 2: Autoload Calls Another Autoload in _init()
**What goes wrong:** Crash or null reference — the second autoload may not exist yet.
**Why it happens:** Autoloads initialize in order, and `_init()` runs before the node tree is ready.
**How to avoid:** Never reference another autoload in `_init()`. Use `_ready()` instead. [CITED: docs.godotengine.org/en/4.6/tutorials/scripting/singletons_autoload.html]
**Warning signs:** Null pointer exceptions on startup with no obvious cause.

### Pitfall 3: Xcode CLI Tools ≠ Xcode.app
**What goes wrong:** iOS export fails completely — Godot requires Xcode.app, not just Command Line Tools.
**Why it happens:** `xcode-select -p` shows CLT path, giving false confidence. Godot's iOS export generates a `.xcodeproj` that requires the full IDE to compile and sign.
**How to avoid:** Install Xcode from the Mac App Store. Verify with `/Applications/Xcode.app` existing. [VERIFIED: environment audit — only CLT installed on this machine]
**Warning signs:** Export preset has no iOS option, or export fails with missing SDK error.

### Pitfall 4: Apple Developer Enrollment Delay
**What goes wrong:** iOS pipeline is planned as single-wave but enrollment takes up to 48 hours.
**Why it happens:** Apple manually reviews new Developer Program enrollments.
**How to avoid:** Start enrollment immediately as Wave 0. Scaffold all autoloads while waiting. [CITED: developer.apple.com/programs/enroll/]

### Pitfall 5: keep_height vs keep_width for Portrait
**What goes wrong:** UI looks correct at 1080x1920 but breaks on phones with non-standard aspect ratios (19:9, 21:9).
**Why it happens:** `keep_height` expands the horizontal view (correct for landscape). `keep_width` adds vertical space (correct for portrait).
**How to avoid:** Always use `keep_width` for portrait games. Locked as D-12.
**Warning signs:** UI clips at top/bottom on tall phones.

### Pitfall 6: Spaces in iOS Export Project Name
**What goes wrong:** Xcode project is generated but immediately corrupted / uncompilable.
**Why it happens:** Godot passes the name as a directory name and Xcode identifier; spaces break both.
**How to avoid:** Use "Lanternkeeper" or "LanternkeeperEmberfall" — no spaces. [CITED: docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html]

### Pitfall 7: CPUParticles2D Instantiation Regression (Godot 4.4+)
**What goes wrong:** Scenes containing CPUParticles2D are significantly slower to instantiate than in Godot 4.3, causing stutter on first load.
**Why it happens:** Documented regression in issue #104360. Status in 4.6.2 is unclear — not confirmed fixed.
**How to avoid:** In Phase 0, no particles are used. For Phase 2+, test instantiation cost early. Consider pre-instantiating particle scenes at startup rather than on-demand. [CITED: github.com/godotengine/godot/issues/104360]

---

## Existing Assets — What's Already Done

**Confirmed present (no action needed):**
- `.gitattributes` — Git LFS tracking for PNG, JPG, JPEG, PSD, TGA, OGG, WAV, MP3, OTF, TTF [VERIFIED: codebase]
- `.gitignore` — Godot 4 ignores (.godot/, export_presets.cfg, .mono/) [VERIFIED: codebase]
- Directory scaffold — `autoloads/`, `scenes/` (5 regions), `shared/` (shaders, themes, ui), `assets/` (audio, fonts, sprites), `data/` (dialogue, quests) [VERIFIED: codebase]
- MkDocs site config — `mkdocs.yml` present, nav structure includes Learning section [VERIFIED: codebase]
- Learning docs scaffold — `docs/learning/getting-started.md`, `gdscript-basics.md`, `gsd-guide.md` exist and are partially populated [VERIFIED: codebase]

**What the learning docs already contain:**
- `getting-started.md` — Godot install steps (Mac + PC), editor overview, running the game, Brackeys + GDQuest + official docs links
- `gdscript-basics.md` — Variables, functions, if/else, signals, `_ready`/`_process`, arrays/dictionaries, naming conventions

**What's missing from learning docs for FOUND-13:**
- No explanation of autoloads as a concept (approachable for Allie)
- No explanation of what each of the 4 autoloads does and why
- No mention of the touch input model
- The existing "Getting Started" page references `project.godot` which doesn't exist yet — update step needed after FOUND-01

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|---|---|---|---|
| `OS.get_window_safe_area()` | `DisplayServer.get_display_safe_area()` | Godot 4.0 | Old method removed; use new one |
| Manual Xcode project creation | Godot exports `.xcodeproj` directly | Godot 3.x+ | No manual Xcode setup needed; open and sign |
| Xcode 15 for App Store | Xcode 16 (current) / Xcode 26 (April 28, 2026) | April 2025 / April 2026 | Phase 0 testing needs Xcode 16; future App Store submission needs Xcode 26 |

---

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Apple Developer enrollment takes up to 48 hours | iOS Pipeline / Pitfall 4 | Could be faster (no risk) or slower if Dave's account needs additional verification | [ASSUMED]
| A2 | The 5th touch input utility (FOUND-07) should be a shared script rather than a registered autoload | Architecture Patterns | Touch utility registered as autoload would also work; architectural preference only |

---

## Open Questions (RESOLVED)

1. **Apple Developer Team ID** — RESOLVED: Plan 04 Task 1 is a human-action checkpoint where Dave enrolls in the Apple Developer Program and provides the Team ID after enrollment. The value is unknown until enrollment completes, which is expected and handled by the checkpoint gate.

2. **Bundle ID** — RESOLVED: Plan 04 Task 1 human-action checkpoint asks Dave to decide the Bundle ID (reverse-domain format). The decision is deferred to execution time because it depends on Dave's domain preference for a personal project.

3. **Touch Input as Autoload vs. Shared Script** — RESOLVED: Plans use `shared/touch_input.gd` as a shared script (not a registered autoload). Plan 01 creates it at that path. Scenes that need gesture detection attach or instantiate it directly.

---

## Security Domain

Security enforcement is not applicable to this phase. Phase 0 produces no networked code, no user-facing authentication, no data transmission. Save files are local binary via `FileAccess.store_var()` with object encoding disabled by default (safe deserialization). No ASVS categories apply.

---

## Sources

### Primary (HIGH confidence)
- CLAUDE.md (project) — full validated tech stack, all locked decisions [VERIFIED: codebase]
- .gitattributes — LFS configuration confirmed present and complete [VERIFIED: codebase]
- docs/learning/ — existing learning doc content confirmed [VERIFIED: codebase]
- Directory scaffold — all directories confirmed present [VERIFIED: codebase]
- environment audit — git-lfs 3.7.1 present; Xcode.app absent; Godot absent [VERIFIED: bash]

### Secondary (MEDIUM confidence)
- [Godot singletons/autoload documentation](https://docs.godotengine.org/en/4.6/tutorials/scripting/singletons_autoload.html) — initialization order, _init() caveat
- [Godot iOS export RST source](https://github.com/godotengine/godot-docs/blob/master/tutorials/export/exporting_for_ios.rst) — Team ID, Bundle ID requirements, project name spaces warning
- [Safe area forum post (Oct 2024)](https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971) — complete MarginContainer implementation
- [Tween in autoload pitfall](https://forum.godotengine.org/t/cannot-tween-audiostreamplayers-in-autoload-scene/49884) — AudioStreamPlayer tween workaround
- [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) — Xcode 16 current, Xcode 26 required April 28, 2026
- [GDQuest save system cheat sheet](https://www.gdquest.com/library/cheatsheet_save_systems/) — FileAccess.store_var() pattern confirmation

### Tertiary (LOW confidence)
- CPUParticles2D instantiation regression (issue #104360) — status in 4.6.2 not confirmed fixed

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all decisions locked in CLAUDE.md and verified against official sources
- Architecture: HIGH — patterns verified via official docs and community sources; code examples cited
- Pitfalls: HIGH — audio tween pitfall has confirmed forum citation; others are well-documented
- iOS pipeline: MEDIUM — Xcode 16 requirements confirmed; specific Godot 4.6 + Xcode 16 compatibility not explicitly tested

**Research date:** 2026-04-10
**Valid until:** 2026-05-10 (30 days; Godot stable, but App Store requirements changed April 28 — recheck before any submission work)
