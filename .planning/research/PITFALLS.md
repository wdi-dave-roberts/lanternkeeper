# Domain Pitfalls: Godot 4.6+ Mobile Game (Lanternkeeper)

**Domain:** Calm/ambient 2D mobile companion game, iOS-first, GDScript
**Researched:** 2026-04-10
**Confidence:** MEDIUM-HIGH (most pitfalls verified across multiple community sources and official issue trackers)

---

## Critical Pitfalls

Mistakes that cause rewrites, App Store rejection, or silent data loss.

---

### Pitfall 1: Minimum iOS Version Mismatch at Export

**What goes wrong:** Godot 4 sets the minimum iOS version in the export template to iOS 11 or 12 by default. The Compatibility renderer requires iOS 12+; the Vulkan/Mobile renderer requires iOS 16. Users on devices running the stated minimum will get a black screen or crash at launch. Apple's review process may not catch this because reviewers use recent hardware.

**Why it happens:** Godot's export dialogue does not currently expose a minimum OS version field for iOS. The value is buried in the generated Xcode project and easily missed.

**Consequences:** App Store distribution to devices that will silently fail. User reviews citing instant crash. Possible App Store rejection for unresponsive launch behavior.

**Prevention:**
- After generating the Xcode project from Godot, immediately set `IPHONEOS_DEPLOYMENT_TARGET` to 16.0 in the Xcode Build Settings (required for 4.6 Compatibility renderer on modern iOS).
- Document this as a required manual step in the export runbook. It is NOT automated.
- Test on the oldest physical device you intend to support before submission.

**Warning signs:** Xcode project opens with deployment target showing 11.0 or 12.0. Any usage of Vulkan/Mobile renderer (not applicable here, but worth knowing).

**Phase:** Phase 0 (iOS pipeline verification) and Phase 11 (App Store submission).

---

### Pitfall 2: iOS Code Signing Conflicts from Godot Export

**What goes wrong:** Godot's iOS export generates an Xcode project where automatic signing is enabled but a specific provisioning profile is also referenced, causing "conflicting provisioning settings" errors that block builds.

**Why it happens:** Godot exports a static Xcode configuration. When you switch between development and distribution signing, residual settings from prior exports conflict.

**Consequences:** Cannot build or archive for App Store. Time lost diagnosing Xcode signing errors instead of making the game.

**Prevention:**
- Treat the exported Xcode project as a build artifact, not a long-lived project. Re-export from Godot rather than accumulating hand-edits.
- In Xcode: set provisioning profile to "Automatic" and let Xcode manage signing. Only switch to manual for final distribution builds.
- Keep Xcode project outside version control or add an explicit note that it is regenerated on each export.

**Warning signs:** "Game has conflicting provisioning settings" in Xcode. Build succeeds in development but fails for Archive.

**Phase:** Phase 0 (pipeline setup) and Phase 11 (submission).

---

### Pitfall 3: Silent Crashes on iOS with No Debug Output

**What goes wrong:** Code that runs correctly in the Godot editor and on Android crashes silently on a real iOS device. No error message, no stack trace — just a crash or black screen.

**Why it happens:** iOS strips debug symbols in release builds. Some GDScript patterns that the editor tolerates (untyped array access, null dereference on a freed node, accessing an autoload before it initializes) fail hard on iOS. The iOS simulator does not reproduce hardware-specific crashes reliably.

**Consequences:** Phase 0 exit criteria appear to be met (works in editor) but the game fails on the device Garrett will actually use.

**Prevention:**
- Test on a real iOS device at the end of Phase 0, before writing any game content. The test is: blank project builds, runs, doesn't crash.
- Enable `debug/gdscript/warnings/enable` in Project Settings and treat all warnings as errors during development.
- Use type hints on all variables and function signatures (already a project convention). Untyped code is more likely to produce silent failures.
- Add null guards before accessing nodes retrieved by `get_node()` or `$`.

**Warning signs:** App launches then immediately shows a black screen on device. Works in editor, fails on device. Crashes only on real hardware, not simulator.

**Phase:** Phase 0 (must catch this before any content work begins).

---

### Pitfall 4: Save Data Loss from Unversioned store_var() Files

**What goes wrong:** `FileAccess.store_var()` saves a binary dictionary. If the data schema changes between game updates (new keys added, keys renamed), loading an old save file will either crash or silently load wrong values because the old dictionary doesn't have the expected keys.

**Why it happens:** `store_var()` is schema-free. There is no version field unless you add one. New code assumes keys exist that old saves don't have.

**Consequences:** Player's progress is lost or corrupted on first game update. For a gift game (single recipient), this is especially painful — Garrett's save could be destroyed by an update.

**Prevention:**
- Include a `schema_version` integer key in every save dictionary from day one.
- Write a migration function that upgrades old save dicts to the new schema: `func _migrate(data: Dictionary) -> Dictionary`.
- Always use `.get("key", default_value)` rather than direct key access when loading saves.
- Test save/load round-trip in Phase 4 when GameState first gets real data.

**Warning signs:** Direct key access patterns like `data["emotion"]` instead of `data.get("emotion", "")`. No version field in the save dictionary.

**Phase:** Phase 0 (GameState scaffold) and Phase 4 (check-in system adds real persistent data).

---

## Moderate Pitfalls

---

### Pitfall 5: Control Nodes Consuming Touch Events

**What goes wrong:** A UI overlay (dialogue box, emotion picker) sits above the game scene. The player tries to swipe fog or brush leaves in the scene behind the UI, but the touch events are consumed by the Control node and never reach the game scene. Gestures stop working whenever the UI is visible.

**Why it happens:** Godot's Control nodes have `Mouse Filter` set to `Stop` by default, which also consumes touch events. This is correct for buttons, wrong for transparent UI layers.

**Consequences:** Ritual interactions (the core mechanic) are blocked by the UI. Debugging this is non-obvious because the scene appears correct — the control is transparent, but it is still eating input.

**Prevention:**
- Set `Mouse Filter = Ignore` on any Control node that is decorative or transparent (dialogue box background panels, scene overlays).
- Only set `Mouse Filter = Stop` on actually interactive controls (buttons, sliders).
- Build a minimal touch test in Phase 3 that confirms touch events reach the game scene when the dialogue box is visible.

**Warning signs:** Swipe/drag stops working when dialogue is visible but works when it's hidden.

**Phase:** Phase 3 (touch system) and Phase 7 (dialogue overlay added over game scene).

---

### Pitfall 6: Tween Errors on Scene Transitions ("Target object freed before starting")

**What goes wrong:** `SceneTransition` triggers a fade-out tween, then calls `change_scene_to_file()`. If the tween's target node (a fade overlay, an animated element) is freed before the tween completes, Godot logs "Target object freed before starting, aborting Tweener" and the transition breaks or leaves the screen in a partial state.

**Why it happens:** `change_scene_to_file()` frees the current scene immediately. Tweens created on scene-owned nodes are orphaned. `await tween.finished` on a freed object does not resume cleanly.

**Consequences:** Screen stuck black or stuck in mid-transition. Requires restart. Happens most often during rapid scene changes (player taps back before animation completes).

**Prevention:**
- Attach the fade overlay to the `SceneTransition` autoload (which persists across scenes), not to the scene being replaced.
- Kill active tweens before initiating any new scene change: `if tween and tween.is_valid(): tween.kill()`.
- Await the tween on the autoload node, not on scene-owned nodes.

**Warning signs:** "Target object freed before starting, aborting Tweener" in the output log during any scene change.

**Phase:** Phase 0 (SceneTransition scaffold) and Phase 2+ (first real scene transitions).

---

### Pitfall 7: Audio Latency on Mobile (>0.5s SFX Delay)

**What goes wrong:** Interaction sounds (leaf brush, lantern click) play with a noticeable delay on mobile. In an ambient game, timing is the tactile feedback — a 500ms delay breaks the feel entirely.

**Why it happens:** Godot's audio system on mobile has documented latency issues, particularly on some Android devices (the issue tracker shows reports since 4.0). iOS is generally better but not immune. Loading audio streams on demand adds additional latency.

**Consequences:** The ritual mechanic feels unresponsive. The connection between gesture and sound — core to the ambient game feel — is broken.

**Prevention:**
- Pre-load all SFX in `AudioManager._ready()`. Do not load audio files on first play.
- Use `AudioStreamPlayer` nodes that are already instantiated and paused, not dynamically created.
- Keep SFX files short and use OGG format for compressed audio (WAV for very short sounds if OGG latency is noticeable).
- Test audio responsiveness on a real iOS device in Phase 0's audio scaffold, not just in the editor.

**Warning signs:** Sounds feel "late" in the editor at low frame rates. Any pattern that creates `AudioStreamPlayer` nodes dynamically (instantiate and play).

**Phase:** Phase 0 (AudioManager scaffold), Phase 10 (full sound pass).

---

### Pitfall 8: Git LFS Not Configured Before First Binary Commit

**What goes wrong:** Binary assets (PNG, OGG, TTF) are committed to the repository before `.gitattributes` is in place. Git tracks them as regular files. The LFS migration later is painful, and if GitHub LFS bandwidth is exceeded, all binary asset pulls fail.

**Why it happens:** It's easy to scaffold the project structure and commit placeholder files before setting up `.gitattributes`. Once a binary file is in regular Git history, it stays there even after LFS migration.

**Consequences:** Repository bloat. LFS migration requires `git lfs migrate import` which rewrites history. Allie's first pull of the repo could fail if bandwidth is exceeded.

**Prevention:**
- Commit `.gitattributes` with LFS tracking rules as the very first commit, before any binary files exist.
- Track at minimum: `*.png`, `*.jpg`, `*.ogg`, `*.wav`, `*.mp3`, `*.ttf`, `*.otf`, `*.webp`, `*.import` (Godot import cache files can be large).
- Verify LFS is working: `git lfs status` should show tracked files after first binary add.

**Warning signs:** `.gitattributes` file is absent from the initial commit. First binary file committed without a corresponding LFS pointer in the working tree.

**Phase:** Phase 0 (repo setup — this must be done first, before any other files).

---

### Pitfall 9: Autoload Initialization Order Causing Null Access

**What goes wrong:** `DialogueManager` calls `GameState.get_player_data()` during its `_ready()`. If `DialogueManager` is listed before `GameState` in Project Settings > Autoloads, `GameState` is not yet initialized when `DialogueManager` tries to use it. This produces a null reference or a call on an incomplete singleton.

**Why it happens:** Godot initializes autoloads in the order they appear in the autoload list. Dependencies between autoloads are not declared, only ordered.

**Consequences:** Startup crash or silent initialization failure. Hard to diagnose because it only manifests at startup, not in isolated testing.

**Prevention:**
- Define the canonical autoload initialization order in a comment at the top of each autoload script: `# Depends on: GameState`.
- Order in Project Settings: `GameState` → `AudioManager` → `SceneTransition` → `DialogueManager`.
- Never call another autoload from `_ready()` unless you have verified the initialization order is correct. Prefer calling from `_on_scene_ready` signals instead.

**Warning signs:** Any autoload that accesses another autoload in `_ready()`. Errors only reproducible at cold start, not when entering a scene from the editor.

**Phase:** Phase 0 (all 4 autoloads scaffolded together).

---

### Pitfall 10: JSON Dialogue Files Breaking at Runtime from Non-Technical Edits

**What goes wrong:** Allie edits a JSON dialogue file in a text editor, introduces a trailing comma, missing quote, or Windows line endings. Godot's `JSON.parse()` silently returns `null` or throws an error. The dialogue system crashes or produces no output at runtime. Allie cannot easily diagnose what went wrong.

**Why it happens:** JSON is strict — a single malformed character fails the entire file. Non-technical editors don't have syntax validation tooling. Godot's JSON error messages show line numbers but not always intuitive descriptions.

**Consequences:** Dialogue stops working after Allie's content edit. She cannot contribute without breaking the game, which undermines the co-developer model.

**Prevention:**
- Write a `DialogueManager._validate_dialogue(data)` function that checks for required keys (`lines`, `speaker`, etc.) and emits clear error messages in debug builds.
- Recommend VS Code with the "JSON" extension as Allie's editor — it validates JSON syntax in real time.
- Add a `data/dialogue/README.md` describing the expected JSON schema with a worked example.
- `DialogueManager` should fail gracefully (show a fallback line, log the error) rather than crashing the scene.

**Warning signs:** Allie edits a JSON file and the game produces no dialogue output. Raw `JSON.parse()` calls without null checks.

**Phase:** Phase 0 (DialogueManager scaffold), Phase 7 (dialogue lines authored).

---

## Minor Pitfalls

---

### Pitfall 11: Safe Area Not Handled for iPhone Notch / Dynamic Island

**What goes wrong:** UI elements (dialogue box, emotion picker, quest display) are positioned based on the 1080x1920 canvas size. On iPhones with notches (iPhone X-15) or Dynamic Island (iPhone 14 Pro+), these elements are partially obscured by the hardware cutout.

**Prevention:**
- Use `DisplayServer.get_display_safe_area()` (Godot 4 API) to retrieve the safe inset values.
- Wrap all interactive UI in a `MarginContainer` that applies the safe area margins in `_ready()`.
- Build this into `shared/ui/` early (Phase 0 or Phase 2) — retrofitting safe area handling into finished scenes is tedious.

**Phase:** Phase 0 or Phase 2 (before any UI scenes are built out).

---

### Pitfall 12: CPUParticles2D Emitter Left Running Offscreen

**What goes wrong:** Fog particle emitters continue processing when the region is not visible (e.g., another scene is loaded but not yet freed, or a panel covers the emitter). On mobile, idle particle processing drains battery and contributes to thermal throttling.

**Prevention:**
- Set `emitting = false` on particle systems when their parent scene is not the active scene.
- Use Godot's built-in `visibility_range_*` properties or connect to `VisibilityNotifier2D` to auto-pause emitters that leave the viewport.
- Keep total active particle count under 200 per scene on mobile.

**Phase:** Phase 2 (first particle work).

---

### Pitfall 13: Stale Scenes After Godot Version Upgrades

**What goes wrong:** After upgrading Godot (e.g., from 4.6.0 to 4.6.1), existing `.tscn` files contain stale internal data. Running `git diff` after opening these scenes in the new editor shows massive diffs even though nothing was intentionally changed.

**Prevention:**
- After every Godot upgrade, open all scenes in the editor and re-save them before committing. This is a known required step.
- Do this as a dedicated commit ("chore: re-save scenes after Godot 4.6.x upgrade") so the diff is isolated and reviewable.

**Phase:** Ongoing throughout all phases.

---

### Pitfall 14: AnimatedSprite2D Sprite Sheet Layout Mismatch

**What goes wrong:** Aetherling's idle animation sprite sheet is authored at one frame size, but `AnimatedSprite2D`'s `hframes`/`vframes` is set to different values. The animation plays with the wrong frames, showing partial or wrong images.

**Prevention:**
- Establish the sprite sheet layout (frame size, grid dimensions) in Phase 1 design parameters before any art is commissioned or drawn.
- Document the expected format in `assets/sprites/aetherling/README.md`.
- Test with a placeholder sprite sheet in Phase 6 before final art arrives.

**Phase:** Phase 1 (design parameters) and Phase 6 (Aetherling sprite).

---

## Phase-Specific Warning Map

| Phase | Topic | Likely Pitfall | Mitigation |
|-------|-------|---------------|------------|
| Phase 0 | Repo init | LFS not set up before binary assets | Commit `.gitattributes` first |
| Phase 0 | iOS pipeline | Minimum iOS version wrong in Xcode | Set deployment target to 16.0 manually |
| Phase 0 | Autoloads | Initialization order causes null access | Order: GameState → AudioManager → SceneTransition → DialogueManager |
| Phase 0 | GameState | Save schema has no version field | Add `schema_version` from day one |
| Phase 0 | SceneTransition | Tween target freed before completion | Fade overlay lives on autoload, not scene |
| Phase 1 | Design | Sprite sheet format not specified | Lock frame size before commissioning art |
| Phase 2 | Particles | Emitters run offscreen | Tie `emitting` to scene visibility |
| Phase 2 | Safe area | UI obscured by notch | MarginContainer with safe area margins |
| Phase 3 | Touch input | Control nodes consume touch events | Set `Mouse Filter = Ignore` on overlays |
| Phase 4 | Save data | New keys crash old save load | Use `.get("key", default)`, add migration |
| Phase 7 | Dialogue | JSON malformed by non-technical edit | VS Code for Allie, validation in loader |
| Phase 10 | Audio | SFX latency breaks ritual feel | Pre-load all audio in AudioManager._ready() |
| Phase 11 | Submission | Provisioning conflicts block App Store | Re-export Xcode project, set signing to Automatic |

---

## Sources

- Godot Engine issue tracker: iOS minimum version (#6360, #7134) — https://github.com/godotengine/godot-proposals/issues/6360
- Godot Engine issue tracker: iOS one-click deploy Xcode 15 (#85539) — https://github.com/godotengine/godot/issues/85539
- Godot Engine issue tracker: Audio latency on mobile (#85442) — https://github.com/godotengine/godot/issues/85442
- Godot Engine issue tracker: AudioStreamPlayer2D latency (#95528) — https://github.com/godotengine/godot/issues/95528
- Godot Engine issue tracker: Tween target freed (#57339) — https://github.com/godotengine/godot/issues/57339
- Godot Forum: Safe area / notch handling — https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971
- Godot Forum: Git LFS best practices — https://forum.godotengine.org/t/best-practices-for-setting-up-git-lfs/75357
- Godot Forum: CPUParticles mobile performance — https://forum.godotengine.org/t/how-to-improve-performance-of-cpuparticles-for-mobiles/22730
- Godot docs: Autoloads vs internal nodes — https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_internal_nodes.html
- Godot docs: Saving games — https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
- Godot docs: Exporting for iOS — https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
- iOS app rejected (unresponsive launch) — https://forum.godotengine.org/t/ios-app-rejected-unresponsive-on-launch/130784
- Mindful Chase: Mobile export troubleshooting — https://www.mindfulchase.com/explore/troubleshooting-tips/mobile-frameworks/godot-engine-troubleshooting-fixing-mobile-export,-performance,-input,-and-rendering-issues.html
