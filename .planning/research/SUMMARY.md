# Project Research Summary

**Project:** Lanternkeeper: Emberfall
**Domain:** Calm / ritual-based 2D mobile companion game (Godot 4.6+, GDScript, iOS-first)
**Researched:** 2026-04-10
**Confidence:** HIGH

## Executive Summary

Lanternkeeper is a calm companion game in the tradition of Monument Valley, Alto's Odyssey Zen Mode, and Viridi — a genre where audio atmosphere, touch rituals, and companion personality are the product, not mechanics or progression systems. Research confirms this genre has well-established design conventions: ambient layered audio is non-negotiable, a companion that feels alive is the emotional core, and touch gestures must be rituals rather than inputs. The MVP is achievable with a focused technical foundation and a single complete world.

The recommended approach is Godot 4.6.2 (Compatibility/OpenGL renderer, GDScript only) with a 4-autoload architecture: GameState, AudioManager, SceneTransition, DialogueManager. Each autoload has a distinct, non-overlapping responsibility. The dialogue system uses hand-rolled JSON rather than Dialogic — the right call for this game's dialogue volume and for Allie's ability to contribute content directly. One critical correction emerged from research: the project spec says `keep_height` for the portrait stretch aspect, but `keep_width` is correct. `keep_height` will letterbox the game on modern tall phones (19:9, 21:9). Fix this in project.godot before any scene layout work.

The primary risk category is iOS pipeline — not Godot itself. Silent crashes on real iOS hardware, minimum iOS version misconfiguration in the Xcode project, and code signing conflicts are all well-documented failure modes with known mitigations. The mitigation is to prove the full export pipeline works in Phase 0, before any content work begins. The secondary risk is content fragility: Allie editing JSON dialogue files without syntax validation tooling can silently break dialogue. VS Code with JSON validation and a graceful fallback in DialogueManager solves this. Both must be in place before Phase 7 dialogue authoring begins.

## Key Findings

### Recommended Stack

The CLAUDE.md technical decisions are validated with one correction and several additions. Godot 4.6.2 stable (not the C# / Mono build) is confirmed correct; GDScript over C# is not a preference — C# has documented launch crashes on Android and reflection crashes on iOS, making it a hard no for mobile. The Compatibility (OpenGL) renderer is correct; Forward+ crashes on AMD desktop hardware used for development and provides no benefit for 2D.

The `keep_width` correction is the most important finding from STACK.md: portrait games need `keep_width` (Vert+) so the view expands vertically on tall phones. `keep_height` (Hor+) is for landscape. This affects every scene layout and must be set correctly before any UI or scene work begins.

**Core technologies:**
- Godot 4.6.2 (Compatibility renderer): game engine — 2D batch rendering improvements, mobile-stable, no AMD Forward+ crashes
- GDScript: scripting — C# is a documented mobile failure, not a tradeoff
- CPUParticles2D: fog/leaf/sparkle particles — GPU particles have a higher fixed base cost; benchmarks show GPU drops to 13 FPS at 5 particles vs CPU holding 35 FPS
- FileAccess.store_var(): game state persistence — binary, native Godot types, injection-safe
- ConfigFile: user settings persistence — INI-like, human-readable, purpose-built for preferences
- Hand-rolled JSON DialogueManager: dialogue — 30 lines of GDScript, zero plugin surface area, Allie edits directly
- AnimatedSprite2D + Tween: animation — right tool for flipbook idles; AnimationPlayer reserved for complex multi-property sequences only
- Git LFS: binary asset tracking — must be configured before the first binary file is committed

**Stack correction:**
- `keep_width` (not `keep_height`) for portrait stretch aspect — change in project.godot before any scene layout

**What to avoid:**
- C# scripting (mobile crashes)
- Forward+ or Mobile renderer (Compatibility only)
- GPUParticles2D for low particle counts
- Dialogic plugin (overkill, version lock burden)
- `OS.get_window_safe_area()` (removed in Godot 4; use `DisplayServer.get_display_safe_area()`)

### Expected Features

The genre has clear table stakes, clear differentiators, and a well-documented set of anti-patterns that undermine the calm experience. Research against Monument Valley, Alto's Odyssey, Viridi, Prune, and Finch confirmed the feature landscape.

**Must have (table stakes):**
- Ambient layered audio (music + environment) — calm games read as broken without atmosphere, not minimalist
- Companion idle animation — a static sprite is a placeholder; Aetherling must feel alive between interactions
- Touch gesture interactions — the ritual layer; without gestures it is a slideshow
- Scene atmosphere (background, particles, ambient light) — each region must feel inhabited
- Dialogue from Aetherling — the emotional core; 15-20 well-written lines per scene exceeds minimum
- Save state persistence — losing progress breaks the calm contract entirely
- Calm, legible UI typography — wrong font (system defaults, hard angles) immediately signals wrong genre
- Per-type volume controls — players expect Music, SFX, and Ambient independently controllable
- Safe area / notch handling — required from day one on iOS hardware
- Graceful first launch — not a tutorial; a single orienting moment where Aetherling notices the player arrived

**Should have (differentiators):**
- Emotional check-in that changes dialogue and quests — most calm apps ignore how you feel; this one responds
- Micro-quests tied to Garrett's actual creative work (Atlas) — a tiny next step, not a task manager
- Hand-written dialogue voice (Allie writes every line) — differentiator is execution quality, not technical complexity
- Reset framed as ritual ("begin again" via lantern relighting animation) — philosophically distinct from failure recovery
- Five distinct ambient regions with unlock progression — one scene is a screensaver; five gives reason to return
- Region unlock tied to emotional variety — unlock by showing up with different emotional states, not arbitrary return count

**Defer to post-MVP:**
- Regions 2-5 — high art/audio/dialogue volume; one complete world ships the gift
- Leaf brushing ritual — second gesture adds variety but depends on art assets
- Return-count dialogue variation — adds depth after core voice is established
- Android export — same codebase; defer until after iOS ships

**Anti-features to never build:**
- Daily streaks (creates guilt, inverts the game's values)
- Push notifications ("Aetherling misses you!" is a dark pattern)
- Scores or performance metrics (destroys the ritual)
- Stamina / energy systems (punishes returning)
- Social comparison / leaderboards (this experience is private)
- Achievement / badge systems (accumulation over presence)
- Monetization hooks (this is a gift, full stop)

### Architecture Approach

The 4-autoload architecture from the project CLAUDE.md is validated as correct. Four autoloads (GameState, SceneTransition, AudioManager, DialogueManager) cover all cross-cutting concerns with distinct, non-overlapping responsibilities and no circular dependencies. The autoload count is conservative — official guidance warns against god objects above 5-10 singletons; 4 is well within safe territory.

One refinement: a fifth lightweight **EventBus** autoload (signals only, no state, no logic) should be added in Phase 4 when the emotional check-in system introduces cross-system communication. Adding it before that point is premature. The architecture file identifies the exact trigger: when `emotion_selected` needs to be observed simultaneously by GameState, DialogueManager, and quest logic.

**Major components:**
1. `GameState` — save/load player state (unlocks, visit count, emotional history, quest history); binary save.dat + settings.cfg kept separate
2. `AudioManager` — 3-bus layout (Music/SFX/Ambient), music crossfade via Tween, pre-loaded SFX pool
3. `SceneTransition` — fade-to-black via CanvasLayer that persists across scene changes; coordinates with AudioManager via signals
4. `DialogueManager` — JSON loading and caching, context-filtered line selection (emotion + visit count + region), emits lines to dialogue_box
5. `EventBus` (Phase 4+) — pure signal relay: emotion_selected, ritual_completed, quest_accepted, region_unlocked
6. Shared UI (instanced into scenes) — dialogue_box, emotion_picker, quest_display; instanced per scene, not autoloaded

**Canonical patterns:**
- Call down, signal up — parents call children directly; children emit signals upward; no `get_parent().get_parent()` chains
- `@export` for node references — paths break silently on refactor; exports fail loudly at scene load
- Signal connections in `_ready()` via code, not editor — greppable, auditable
- Past-tense signal names: `emotion_selected`, `lantern_lit`, `dialogue_finished`

**Autoload initialization order** (must match this sequence in Project Settings):
GameState → AudioManager → SceneTransition → DialogueManager

### Critical Pitfalls

**Critical (cause rewrites, data loss, or App Store rejection):**

1. **`keep_height` aspect in project.godot** — Wrong setting for portrait. Use `keep_width`. Fix before any scene layout work or all UI positioning will be wrong on modern tall phones.

2. **iOS minimum version not set in Xcode project** — Godot exports with iOS 11/12 default. Compatibility renderer requires iOS 16. Set `IPHONEOS_DEPLOYMENT_TARGET = 16.0` in Xcode Build Settings manually after every Godot export. Document as a required step in the export runbook.

3. **Silent iOS crashes with no debug output** — Code that runs in the editor can crash silently on real iOS hardware. Prove the full pipeline (build, sign, install, run) on a physical device at the end of Phase 0, before any content work. Enable GDScript warnings and treat them as errors.

4. **Unversioned save schema** — `store_var()` is schema-free. Adding or renaming keys in an update corrupts old saves. Add `schema_version: 1` to every save dict from day one. Use `.get("key", default)` for all key access. Write a `_migrate()` function before Phase 4.

5. **Git LFS not configured before first binary commit** — Once a binary is in regular Git history, migration requires rewriting history. Commit `.gitattributes` with LFS tracking rules as the very first commit.

**Moderate (cause debugging time or UX breakage):**

6. **Control nodes consuming touch events** — Dialogue box and emotion picker overlays have `Mouse Filter = Stop` by default, blocking touch events to the game scene. Set `Mouse Filter = Ignore` on all decorative/transparent overlays. The ritual mechanic stops working whenever UI is visible.

7. **Tween target freed during scene transition** — The fade overlay must live on the SceneTransition autoload, not on the scene being replaced. Kill active tweens before initiating any new transition.

8. **Audio latency on mobile** — SFX loading on first play adds latency that breaks the ritual feel. Pre-load all audio streams in `AudioManager._ready()`. Test responsiveness on real iOS hardware in Phase 0.

9. **JSON dialogue files broken by non-technical edits** — Set Allie up with VS Code + JSON extension. Add validation with graceful fallback in `DialogueManager`. Add `data/dialogue/README.md` with format example before she writes any lines.

10. **Autoload initialization order causes null access at cold start** — Never access another autoload in `_init()`. Order in Project Settings: GameState → AudioManager → SceneTransition → DialogueManager.

## Implications for Roadmap

The architecture file provides the clearest statement of build order constraints: autoloads must exist before scenes use them; the JSON schema must be locked before Allie writes content; the iOS pipeline must be proven before any content work begins. These constraints drive the phase ordering below.

### Phase 0: Foundation and Verified iOS Pipeline
**Rationale:** Every subsequent phase depends on this. Silent iOS crashes and LFS history corruption are both impossible to fix cheaply after the fact. This phase has no features Garrett would see — that is intentional.
**Delivers:** Verified build pipeline (editor → iOS device), 4 autoload scaffolds, Git LFS configured, project settings correct (`keep_width`, Compatibility renderer, 1080×1920), blank project running on physical iOS hardware
**Avoids:** Pitfalls 1-5 (keep_width, iOS version, silent crashes, save schema, LFS), Pitfall 7 (tween fade overlay on autoload), Pitfall 9 (autoload init order)
**Research flag:** Standard patterns — skip phase research. The pitfall doc covers everything actionable.

### Phase 1: Design Parameters and Content Contracts
**Rationale:** The sprite sheet format must be locked before art is drawn. The JSON dialogue schema must be locked before Allie writes lines. The emotional state names must exist before any content references them. This is a decision phase, not a build phase.
**Delivers:** Locked sprite sheet format (frame size, grid), locked JSON dialogue schema, 4 emotional state names, region names and unlock criteria, Allie's editor setup (VS Code + JSON extension), `data/dialogue/README.md`
**Avoids:** Pitfall 14 (sprite sheet layout mismatch), Pitfall 10 (JSON breakage from non-technical edits)
**Research flag:** Skip. Decisions, not implementation.

### Phase 2: Lantern Clearing — First Playable Scene
**Rationale:** Proves the scene structure, particle system, audio integration, and safe area handling working together. This scene is the template for all 5 regions — getting it right here means the others are mechanical replications.
**Delivers:** One ambient scene with fog CPUParticles2D, ambient audio track, placeholder Aetherling node, safe area margins applied via MarginContainer
**Uses:** AudioManager crossfade, CPUParticles2D, DisplayServer.get_display_safe_area()
**Avoids:** Pitfall 11 (safe area), Pitfall 12 (particles running offscreen)
**Research flag:** Skip. Standard Godot 2D scene composition.

### Phase 3: Touch Ritual System
**Rationale:** The fog clearing gesture is the primary interaction and the ritual layer. Must be proven before the UI overlay is added on top, otherwise touch event consumption bugs are harder to isolate.
**Delivers:** Swipe-to-clear fog gesture with visual feedback, haptic feedback on completion, gesture thresholds in project constants
**Uses:** InputEventScreenTouch / InputEventScreenDrag, custom gesture utility script
**Avoids:** Pitfall 5 (Control nodes consuming touch — test before UI layer exists)
**Research flag:** Skip. InputEventScreenTouch is well-documented.

### Phase 4: Emotional Check-In and GameState
**Rationale:** This is the spine of the game — emotional state drives dialogue selection, quest selection, and region unlock. Everything from here forward depends on emotional state being stored reliably. This is also when EventBus earns its place.
**Delivers:** EmotionPicker UI (4 states), emotional state persisted in GameState, save/load round-trip tested with versioned schema, EventBus autoload added, `emotion_selected` signal wired
**Uses:** ConfigFile (settings), FileAccess.store_var() (game state), EventBus for cross-system signals
**Avoids:** Pitfall 4 (unversioned save schema — migration function added here), Pitfall 6 (Mouse Filter on EmotionPicker)
**Research flag:** Skip. Patterns are well-established.

### Phase 5: Micro-Quest System
**Rationale:** Quests require emotional state (Phase 4) and DialogueManager's context filtering. Quest content is Allie's first writing contribution — set her up to succeed before she starts.
**Delivers:** `data/quests/micro_quests.json` schema finalized, 16-20 quests (4-5 per emotional state) from Allie, QuestDisplay UI, DialogueManager context filtering (emotion + visit_count + region)
**Avoids:** Pitfall 10 (JSON validation — same fragility as dialogue JSON; same validation approach applies)
**Research flag:** Skip. Dialogue loading pattern is established.

### Phase 6: Aetherling Sprite and Idle Animation
**Rationale:** Can be parallelized with Phases 3-5 if art assets are ready. No system dependencies beyond Phase 2. Listed here because art assets may need lead time and this phase gates Phase 7.
**Delivers:** AnimatedSprite2D with SpriteFrames resource, at minimum 1 idle loop, placeholder sprite sheet for testing before final art
**Avoids:** Pitfall 14 (sprite sheet layout mismatch — test with placeholder before final art arrives)
**Research flag:** Skip. AnimatedSprite2D is well-documented; complexity is art production.

### Phase 7: Dialogue System — Aetherling Speaks
**Rationale:** DialogueManager exists from Phase 0 but carries no content until now. Requires Phase 6 (Aetherling exists) and Phase 4 (emotional state for dialogue selection). Allie writes all lines.
**Delivers:** dialogue_box shared UI component, 15-20 dialogue lines per emotional state in lantern_clearing.json (Allie), DialogueManager wired to dialogue_box
**Avoids:** Pitfall 5 (Mouse Filter — dialogue box must not consume touch events), Pitfall 10 (VS Code + validation must be in place)
**Research flag:** Skip for implementation. Dialogue content quality is Allie's domain.

### Phase 8: First Launch and Reset Ritual
**Rationale:** First launch is distinct from normal flow — Aetherling notices the player arrived. Reset (lantern relighting) is the emotional centerpiece that frames "begin again" as ritual. Both require all prior systems.
**Delivers:** First-launch dialogue variant (visit_count = 0 branch), lantern relighting animation, reset mechanic that clears visual state while preserving emotional history
**Uses:** GameState (visit_count), DialogueManager, AnimatedSprite2D (lantern relighting frames)
**Research flag:** Skip. Logic is straightforward given the existing architecture.

### Phase 9: Settings and Polish
**Rationale:** Volume controls, particle toggle for older devices. Polish pass before testing with Garrett.
**Delivers:** Three independent volume sliders (Music, SFX, Ambient) persisted in ConfigFile, particle toggle in settings
**Research flag:** Skip. ConfigFile pattern is established.

### Phase 10: Full Audio Pass
**Rationale:** Audio is a first-class feature in this genre, not polish. All SFX pre-loaded. All regions have complete ambient layers. Haptic feedback verified. Tested on iOS for latency.
**Delivers:** Complete ambient audio for lantern_clearing, all SFX pre-loaded in AudioManager._ready(), haptic feedback via Input.vibrate_handheld(), audio latency verified on physical iOS device
**Avoids:** Pitfall 7 (audio latency — pre-load all streams, test on device)
**Research flag:** Skip. Pattern is established; this is execution and tuning.

### Phase 11: Regions 2-5 (Post-MVP Expansion)
**Rationale:** Each region is a mechanical replication of the Phase 2 scene structure with new art, audio, dialogue, and particle profile. Region unlock logic (emotional variety trigger) is already live from Phase 4.
**Delivers:** 4 additional regions (workshop_glade, fog_valley, warm_river, observatory_balcony) each with unique art, ambient audio, CPUParticles2D profile, and Allie-written dialogue set
**Research flag:** Standard patterns. Skip.

### Phase 12: App Store Submission
**Rationale:** iOS pipeline was proven in Phase 0 but submission has additional requirements that change annually.
**Delivers:** App Store listing, signed IPA, successful review
**Avoids:** Pitfall 2 (iOS code signing conflicts — re-export Xcode project, set signing to Automatic), Pitfall 1 (iOS minimum version — verify deployment target is 16.0 in every export)
**Research flag:** Needs research-phase during planning. App Store submission requirements (privacy manifests, required API declarations, screenshot specs) change yearly. Do not plan Phase 12 without current Apple documentation.

### Phase Ordering Rationale

- Phase 0 is non-negotiable first. iOS pipeline failures discovered in Phase 11 are catastrophic; discovered in Phase 0 are a one-week fix.
- Phase 1 (design parameters) before Phase 2 (first scene) because sprite sheet format and JSON schema cannot change after art and content exist.
- Phase 3 (touch) before Phase 7 (dialogue overlay) so touch event consumption bugs are isolated, not confounded by UI layers.
- Phase 4 (emotional check-in) before Phases 5 and 7 because both depend on emotional state being stored reliably.
- Phase 6 (Aetherling sprite) can run parallel to Phases 3-5 if art assets are available; it strictly gates Phase 7.
- Phases 11-12 are post-MVP. The gift works without them — one complete world is the goal.

### Research Flags

Phases needing deeper research during planning:
- **Phase 12 (App Store Submission):** Apple review requirements, privacy manifest requirements for iOS 17+ apps, screenshot sizes, and App Store Connect metadata change annually. Verify at submission time.

Phases with standard patterns (skip research-phase):
- **Phase 0:** Pitfalls are documented and mitigated. Setup sequence is mechanical.
- **Phases 1-11:** Godot 2D patterns are well-documented. Architecture decisions are locked. Implementation requires skill, not research.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All decisions verified against official Godot docs and community benchmarks. One correction found (keep_width vs keep_height) — documented and actionable. |
| Features | HIGH | Genre conventions well-documented across multiple published games. Anti-features validated against peer-reviewed dark patterns research (arxiv 2024). |
| Architecture | HIGH | Matches official Godot best practices documentation. Autoload pattern is community consensus. EventBus timing is the one judgment call (MEDIUM for that specific decision). |
| Pitfalls | MEDIUM-HIGH | iOS pipeline pitfalls verified on official issue tracker. Audio latency is a known open issue. App Store requirements require verification at submission time. |

**Overall confidence:** HIGH

### Gaps to Address

- **Unlock trigger design:** Research confirmed emotional variety as unlock trigger is the right philosophy, but the exact mechanic (how many different states? over how many sessions?) is an outstanding decision. Decide in Phase 1 design parameters.
- **Aetherling expression frames:** Number and nature of expression frames (idle, curious, warm, focused) is a Phase 1 art direction decision. Must be decided before Phase 6 art commission.
- **iOS minimum version at export time:** Research says set deployment target to 16.0. Verify this is still correct for Godot 4.6.2 Compatibility renderer at actual export time — this can shift with Godot point releases.
- **App Store requirements at submission:** Privacy manifest requirements for iOS 17+, required API declarations, and screenshot specifications change yearly. Do not plan Phase 12 without current Apple documentation.

## Sources

### Primary (HIGH confidence)
- Godot 4.6.2 stable release / official engine docs — engine version, renderer, stretch aspect, safe area API
- Godot saving games (official docs) — FileAccess.store_var() and ConfigFile patterns
- Godot autoloads vs internal nodes (official docs) — autoload architecture validation
- Godot iOS export (official docs) — export pipeline requirements
- Godot multiple resolutions (official docs) — keep_width vs keep_height correction
- Android portrait keep_width recommendation (developer.android.com/games/engines/godot) — stretch aspect confirmation
- CPU vs GPU Particles 2D performance study (community, June 2024) — CPUParticles2D at low counts
- Dark patterns in mobile games (arxiv 2024, peer-reviewed) — anti-feature validation
- Designing for Coziness (Game Developer) — genre feature conventions

### Secondary (MEDIUM confidence)
- GDQuest crossfade music tutorial — AudioManager crossfade pattern
- GDQuest EventBus singleton tutorial — EventBus pattern and timing
- KidsCanCode Godot 4 Recipes (node communication) — call down, signal up validation
- Godot Forum: safe area / notch handling — DisplayServer.get_display_safe_area() usage
- Godot Forum: Git LFS best practices — .gitattributes configuration
- Monument Valley design analysis, Alto's Odyssey Zen Mode — genre feature mapping
- Finch companion app (app store observation) — emotional check-in pattern

### Tertiary (LOW confidence)
- App Store submission requirements — Apple policies change annually; verify at submission time

---
*Research completed: 2026-04-10*
*Ready for roadmap: yes*
