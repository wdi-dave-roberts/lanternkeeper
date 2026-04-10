# Architecture Patterns: Lanternkeeper Emberfall

**Domain:** Calm mobile 2D companion game (Godot 4.6+, GDScript)
**Researched:** 2026-04-10
**Overall confidence:** HIGH for Godot patterns, MEDIUM for game-type-specific patterns

---

## Verdict on the Proposed 4-Autoload Architecture

**Validated with one refinement.**

The 4-autoload structure (GameState, SceneTransition, AudioManager, DialogueManager) is sound and well-matched to this game's scale. The autoload count is conservative — official guidance warns against "god objects" above 5-10 singletons; 4 is well within safe territory. Each autoload has a distinct, non-overlapping responsibility. No circular dependencies exist in the proposed design. This is the right structure.

The one refinement: consider a fifth lightweight autoload — an **EventBus** — for cross-system communication. Without it, DialogueManager and GameState will need direct references to communicate quest completion, emotional check-ins, and unlock triggers. An EventBus autoload (signals only, no state) decouples these cleanly at near-zero cost.

---

## Recommended Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        AUTOLOADS (always live)                  │
│                                                                 │
│   GameState          SceneTransition    AudioManager            │
│   (state/save)       (scene changes)    (audio buses)           │
│                                                                 │
│   DialogueManager    [EventBus]                                 │
│   (JSON/playback)    (cross-system signals, optional)           │
└─────────────────────────────────────────────────────────────────┘
                              │
                    signals / method calls
                              │
┌─────────────────────────────────────────────────────────────────┐
│                        SCENES (loaded on demand)                │
│                                                                 │
│   lantern_clearing  workshop_glade  fog_valley                  │
│   warm_river        observatory_balcony                         │
│                                                                 │
│   Each scene: root Node2D + region script + instanced shared UI │
└─────────────────────────────────────────────────────────────────┘
                              │
                    instances shared components
                              │
┌─────────────────────────────────────────────────────────────────┐
│                        SHARED UI (instantiated into scenes)     │
│                                                                 │
│   dialogue_box      emotion_picker     quest_display            │
└─────────────────────────────────────────────────────────────────┘
                              │
                    reads content from
                              │
┌─────────────────────────────────────────────────────────────────┐
│                        DATA (files, not nodes)                  │
│                                                                 │
│   data/dialogue/*.json       data/quests/micro_quests.json      │
└─────────────────────────────────────────────────────────────────┘
```

---

## Component Boundaries

### GameState (`autoloads/game_state.gd`)

**Owns:** All persistent player data. Unlocked regions, visit count, emotional history (last N check-ins), active quest, Aetherling relationship flags.

**Does not own:** UI state, scene-local visual state, audio settings (those go in ConfigFile via AudioManager).

**Communicates with:**
- Written to by DialogueManager (when dialogue gates a flag) and scene scripts (when a ritual is completed)
- Read by SceneTransition (to know which scene to load on cold start), DialogueManager (to select correct dialogue variant), shared UI components (quest_display reads active quest)

**Save strategy:** `FileAccess.store_var()` for game state to `user://save.dat`. `ConfigFile` for audio/settings to `user://settings.cfg`. These are separate files — settings should survive a save reset.

**Initialization order note:** Other autoloads must not access GameState in `_init()`. Access only in `_ready()` or later. Godot does not guarantee autoload initialization order.

---

### SceneTransition (`autoloads/scene_transition.tscn` + `.gd`)

**Owns:** The CanvasLayer with a full-screen ColorRect (black, highest z-index), the tween logic for fade-in/fade-out, and the `change_scene_to_file()` call.

**Does not own:** Decisions about which scene to load (callers provide that), audio crossfades (AudioManager owns those).

**Communicates with:**
- Called by region scene scripts when the player triggers a scene change
- Emits a signal (`transition_finished`) so AudioManager can start the new ambient track at the right moment

**Implementation pattern (validated):** A `.tscn` autoload (not just `.gd`) is correct here because you need actual nodes (CanvasLayer, ColorRect). The scene lives above all game scenes in the tree, so the overlay renders on top of everything. Use `get_tree().create_tween()` for the alpha tween.

**Coordination with AudioManager:** SceneTransition should emit `transition_started` before the fade and `transition_finished` after. AudioManager listens to start the crossfade. This avoids SceneTransition needing a direct reference to AudioManager (respects signal-up direction).

---

### AudioManager (`autoloads/audio_manager.tscn` + `.gd`)

**Owns:** The 3-bus layout (Music, SFX, Ambient), AudioStreamPlayer nodes for music and ambient channels, crossfade tween logic, and the SFX pool (a small array of AudioStreamPlayers for concurrent sound effects).

**Does not own:** Which audio file to play (callers provide paths), volume user preferences (read from GameState's ConfigFile on startup).

**Communicates with:**
- Called by scene scripts: `AudioManager.play_sfx("res://assets/audio/sfx/tap.ogg")`
- Called by scene scripts or EventBus: `AudioManager.crossfade_music("res://assets/audio/music/clearing.ogg")`
- Reads volume settings from ConfigFile on `_ready()`

**Bus layout:** Music bus for looping background tracks. Ambient bus for looping environmental sounds (crickets, wind). SFX bus for one-shot interaction sounds. The 3-bus structure allows master volume + independent volume sliders in settings without any code changes.

**Mobile note:** AudioStreamPlayer (not AudioStreamPlayer2D) for all channels since this is a non-spatial, portrait-locked game. No positional audio needed.

---

### DialogueManager (`autoloads/dialogue_manager.gd`)

**Owns:** JSON file loading and caching, the active dialogue sequence state (current line index, current speaker), and the signal that advances or closes dialogue.

**Does not own:** The dialogue box visual (that's `shared/ui/dialogue_box.tscn`), which JSON file to load (region scenes provide the path), or what happens after dialogue ends (GameState/scene scripts handle that via signals).

**Communicates with:**
- Called by region scene scripts: `DialogueManager.load_dialogue("res://data/dialogue/lantern_clearing.json")`
- Emits `dialogue_line_ready(speaker: String, line: String)` — dialogue_box listens
- Emits `dialogue_finished()` — scene script listens to resume gameplay

**Dialogue selection:** DialogueManager should accept a `context: Dictionary` parameter containing `{"emotion": "focused", "visit_count": 3, "region": "lantern_clearing"}` drawn from GameState. It filters the JSON entries by matching context fields, then picks randomly among matches. This keeps variant selection logic in one place and makes the JSON format readable.

**JSON format (recommended):**
```json
[
  {
    "id": "morning_greeting_focused",
    "speaker": "Aetherling",
    "conditions": {"emotion": "focused"},
    "line": "You're back. Something's clicking today, isn't it?"
  }
]
```

---

### EventBus (optional fifth autoload, `autoloads/event_bus.gd`)

**Owns:** Only signal declarations. No state, no logic.

**When to add it:** Add it in Phase 4 (emotional check-in) when GameState, DialogueManager, and scene scripts start needing to react to the same events. Without it, you will start passing references through 3+ hops or calling autoloads from inside other autoloads.

**Signals it would carry:**
```gdscript
signal emotion_selected(emotion: String)
signal ritual_completed(ritual_name: String)
signal quest_accepted(quest_id: String)
signal region_unlocked(region_name: String)
```

**Decision:** Don't add it in Phase 0. Add it when the first cross-system communication problem appears. The 4-autoload structure is sufficient for Phases 0-3.

---

## Data Flow

### Cold Start (first open)
```
app launch
  → GameState._ready() loads save.dat (or creates default state)
  → AudioManager._ready() reads settings.cfg for volumes
  → SceneTransition loads "lantern_clearing" (always home on first open)
  → lantern_clearing.gd reads GameState.visit_count (is 0)
  → plays "first arrival" dialogue variant
```

### Return Visit (Nth open)
```
app launch
  → GameState loads existing save
  → visit_count incremented
  → region = GameState.last_region (could be any unlocked scene)
  → appropriate ambient audio starts
  → Aetherling idle animation plays
  → player performs ritual (fog swipe / leaf brush)
  → scene script emits ritual_completed (or calls GameState directly)
  → dialogue_box activates, DialogueManager provides contextual line
  → emotion_picker shown
  → GameState.save() called after emotion selected
```

### Scene Transition (region change)
```
player triggers region change
  → region_scene.gd calls SceneTransition.go_to("res://scenes/workshop_glade/...")
  → SceneTransition tweens ColorRect alpha to 1.0 (black out)
  → SceneTransition emits transition_started
  → AudioManager crossfades ambient audio (old → new)
  → get_tree().change_scene_to_file() called
  → new scene _ready() fires
  → SceneTransition tweens alpha back to 0.0
  → SceneTransition emits transition_finished
```

### Dialogue Playback
```
scene script calls DialogueManager.load_dialogue(path, context)
  → DialogueManager parses JSON, filters by context, picks line
  → DialogueManager emits dialogue_line_ready(speaker, line)
  → dialogue_box.gd receives signal, animates text in
  → player taps to advance
  → dialogue_box emits advance_requested
  → DialogueManager advances or emits dialogue_finished
  → scene script receives dialogue_finished, resumes gameplay
```

---

## Patterns to Follow

### Call Down, Signal Up (validated as Godot's canonical pattern)

Parent nodes call child methods directly. Children communicate upward via signals. This makes each scene independently testable and prevents brittle path-based references.

**Correct:**
```gdscript
# Parent configures child directly
$DialogueBox.set_speaker("Aetherling")

# Child signals upward
signal advance_requested
func _on_tap():
    advance_requested.emit()
```

**Incorrect:**
```gdscript
# Child reaching up the tree — fragile
get_parent().get_parent().resume_gameplay()
```

### @export for Node References

Use `@export` to assign child node references in the Inspector rather than hardcoded `get_node()` paths. Paths break silently on refactor; exports fail loudly at scene load.

```gdscript
@export var aetherling_sprite: AnimatedSprite2D
@export var fog_emitter: CPUParticles2D
```

### Signal Connections in Code, Not Editor

Connect all signals in `_ready()` via code. Editor connections become invisible as the project grows and cause "why is this firing?" debugging sessions. Code connections are greppable.

```gdscript
func _ready() -> void:
    DialogueManager.dialogue_line_ready.connect(_on_dialogue_line_ready)
    DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
```

### Past-Tense Signal Names

Signals describe what happened, not commands. `emotion_selected`, not `select_emotion`. `lantern_lit`, not `light_lantern`. This distinction matters when reading signal connection code.

---

## Anti-Patterns to Avoid

### Storing Scene-Specific State in Autoloads

Autoloads persist across scene changes. If you store "is the fog currently showing" in GameState, you'll have state leak bugs when scenes unload. Keep visual/transient state local to scenes.

**Wrong:** `GameState.fog_visible = false`
**Right:** `$FogEmitter.emitting = false` (local to scene)

### Accessing Autoloads in `_init()`

`_init()` runs before the scene tree is ready. Autoloads may not exist yet. Always access autoloads in `_ready()` or later.

### Connecting the Same Signal Twice

If you connect signals in `_ready()` and your scene is reloaded, you'll double-connect. Either check `is_connected()` first, or connect once in `_ready()` and disconnect in `_exit_tree()`.

### Putting Logic in the EventBus

The EventBus (if added) must be a pure signal relay — no state, no methods that do work. The moment it has logic, it becomes a second GameState and you lose the ability to reason about data flow.

### Using AnimationPlayer for Simple Flipbook Idles

AnimationPlayer is powerful but heavy to set up for a simple 3-frame idle loop. AnimatedSprite2D with a SpriteFrames resource is the right tool for Aetherling's idle animation. Use AnimationPlayer only if you need to animate non-frame properties (position, scale, color) in the same animation.

---

## Scene Structure (per region)

Each of the 5 region scenes follows the same structure:

```
RegionName (Node2D)
  Background (Sprite2D or TextureRect)
  AmbientLayer (Node2D)
    FogEmitter (CPUParticles2D)      ← emitting = false by default
    LeafEmitter (CPUParticles2D)
    SparkleEmitter (CPUParticles2D)
  Aetherling (AnimatedSprite2D)      ← idle animation loops continuously
  InteractionZone (Area2D)           ← touch target for rituals
    CollisionShape2D
  UILayer (CanvasLayer)              ← UI always renders above world
    DialogueBox (instanced from shared/)
    EmotionPicker (instanced from shared/)
    QuestDisplay (instanced from shared/)
```

The `UILayer` as a CanvasLayer within the scene (not a separate scene) ensures UI renders on top of particles and sprites without needing a global UI layer.

---

## Build Order Implications

The architecture has hard dependencies that constrain build order:

```
Phase 0 (Foundation) — must come first
  GameState (no dependencies)
  SceneTransition (no dependencies beyond CanvasLayer)
  AudioManager (no dependencies)
  DialogueManager (depends on JSON schema being finalized)
  Touch input utility (needed by all interaction scenes)

Phase 2 (First Scene) — depends on Phase 0
  Requires GameState to exist (visit count, unlocks)
  Requires SceneTransition to exist (even if not yet used)
  Requires AudioManager to exist (ambient audio)

Phase 3 (Rituals) — depends on Phase 2
  Touch interaction depends on InteractionZone being in scene structure
  CPUParticles2D configuration depends on art direction (Phase 1 decision)

Phase 4 (Check-In) — depends on Phase 3
  EmotionPicker UI depends on GameState.save() being reliable
  This is when EventBus becomes worth adding

Phase 5 (Quests) — depends on Phase 4
  micro_quests.json schema must be finalized
  DialogueManager must already load and filter by context

Phase 6 (Aetherling sprite) — depends on Phase 2
  AnimatedSprite2D + SpriteFrames — no system dependencies, only asset dependencies
  Can be parallelized with Phase 3-5 if art assets are ready

Phase 7 (Dialogue) — depends on Phase 6 + Phase 4
  Needs Aetherling to exist (speaker)
  Needs emotional state in GameState (for dialogue selection)
```

The constraint that matters most for scheduling: **DialogueManager's JSON schema must be finalized before Allie writes any dialogue.** If the format changes after she's written 50 lines, every line needs migration. Lock the schema in Phase 0.

---

## Scalability Considerations

| Concern | For this game (5 scenes) | If scope expands |
|---------|--------------------------|-----------------|
| Autoload count | 4-5 is safe | Stay under 10; extract to class_name if needed |
| JSON loading | Load-and-cache on first access is fine | Lazy-load per scene if memory is a concern |
| Save file | Single `save.dat` is fine | Consider versioning the save schema from day 1 |
| Particle emitters | 3 per scene × 5 scenes = 15 total, well within budget | Disable non-visible scene emitters immediately on scene change |
| Dialogue lines | 200-500 lines is fine in memory | Paginate per-region; only load current region's file |

---

## Confidence Assessment

| Decision | Confidence | Basis |
|----------|------------|-------|
| 4-autoload structure | HIGH | Matches official Godot best practices; 4 is well under the god-object threshold |
| Call down, signal up | HIGH | Official Godot documentation + multiple practitioner sources |
| EventBus as optional 5th autoload | MEDIUM | Common pattern in Godot community; timing of when to add it is judgment call |
| FileAccess.store_var() for save | HIGH | Official docs + community consensus; binary format is safe against injection |
| AnimatedSprite2D for Aetherling idle | HIGH | Clear community consensus for simple flipbook animation |
| CPUParticles2D at low counts | HIGH | Community performance study shows GPU base cost is higher than CPU at low particle counts |
| JSON dialogue with context filtering | MEDIUM | Pattern is common but specific implementation is original to this project |
| Scene structure per region | HIGH | Standard Godot 2D scene composition pattern |

---

## Sources

- [Autoloads versus internal nodes — Official Godot Docs](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_internal_nodes.html)
- [Node communication (the right way) — KidsCanCode Godot 4 Recipes](https://kidscancode.org/godot_recipes/4.x/basics/node_communication/index.html)
- [Call Down Signal Up — GoGoGodot](https://www.gogogodot.io/patterns/call-down-signal-up/)
- [Godot Signals Architecture 2026 — Febucci](https://blog.febucci.com/2024/12/godot-signals-architecture/)
- [The Events Bus Singleton — GDQuest](https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/)
- [CPU vs GPU Particles 2D Performance Study — Godot Forum](https://forum.godotengine.org/t/cpu-vs-gpu-particles-2d-performance-study-careful-gpu-particles-seem-to-have-a-high-base-cost/67850)
- [AnimatedSprite2D vs AnimationPlayer — UhiyamaLab](https://uhiyama-lab.com/en/notes/godot/animatedsprite2d-vs-animationplayer-comparison/)
- [Saving games — Official Godot Docs](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html)
- [Scene Transitions — GDQuest](https://www.gdquest.com/tutorial/godot/2d/scene-transition-rect/)
