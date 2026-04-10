# Requirements: Lanternkeeper: Emberfall

**Defined:** 2026-04-10
**Core Value:** Gentle, guilt-free creative companionship — the player feels cared for without pressure.

## v1 Requirements

Requirements for Milestone 1 (Phases 0-1). Phase 2+ requirements will be defined as the final step of Phase 1, after Allie's design decisions land.

### Foundation (Phase 0 — Dave solo)

- [ ] **FOUND-01**: Godot 4.6+ project initialized with Compatibility renderer, 1080x1920 portrait, canvas_items stretch, `keep_width` aspect
- [ ] **FOUND-02**: 4 autoloads registered in correct order: GameState, AudioManager, SceneTransition, DialogueManager — each with skeleton implementation
- [ ] **FOUND-03**: GameState autoload saves/loads player state via FileAccess.store_var() with `schema_version: 1` key and `.get("key", default)` access pattern
- [ ] **FOUND-04**: SceneTransition autoload fades between scenes via tween on a persistent CanvasLayer (overlay lives on autoload, not on scenes)
- [ ] **FOUND-05**: AudioManager autoload has 3-bus layout (Music, SFX, Ambient) with crossfade skeleton and pre-loaded SFX pool
- [ ] **FOUND-06**: DialogueManager autoload loads JSON from `data/dialogue/`, emits signals for line playback
- [ ] **FOUND-07**: Touch input utility detects tap, swipe, and drag with configurable thresholds, using InputEventScreenTouch/InputEventScreenDrag
- [ ] **FOUND-08**: Git LFS configured via .gitattributes for PNG, OGG, WAV, TTF — committed before any binary assets
- [ ] **FOUND-09**: Project directory scaffold created: autoloads/, scenes/, shared/, assets/, data/dialogue/, data/quests/
- [ ] **FOUND-10**: Emulate Touch From Mouse enabled in Project Settings for desktop testing
- [ ] **FOUND-11**: Blank project builds, exports, and runs on a physical iOS device — full pipeline verified (build, sign, install, run)
- [ ] **FOUND-12**: Safe area MarginContainer pattern wired into root UI structure using DisplayServer.get_display_safe_area()
- [ ] **FOUND-13**: Learning resources prepared for Allie: Brackeys Godot intro bookmarks, GDQuest bookmarks, GDScript cheat sheet

### Design Parameters (Phase 1 — Dave + Allie)

- [ ] **DESIGN-01**: Session design resolved — target session length, daily cadence, behavior on repeated opens vs. long absence
- [ ] **DESIGN-02**: Progression and unlock criteria defined — what unlocks the 5 regions, linear vs. player-chosen, revisiting policy
- [ ] **DESIGN-03**: Aetherling character voice defined — dialogue volume target, variation axes (region/emotion/return count), personality guidelines
- [ ] **DESIGN-04**: 4 emotional state names chosen and documented
- [ ] **DESIGN-05**: Micro-quest system designed — quests per emotion, rotation strategy, fire-and-forget vs. completion tracking
- [ ] **DESIGN-06**: Reset mechanic framing decided — what resets (visual only vs. check-in vs. progress), narrative framing
- [ ] **DESIGN-07**: Art direction decided — style (pixel/illustrated/watercolor/low-poly), asset source (Allie draws/packs/commissioned), Aetherling visual design
- [ ] **DESIGN-08**: Sound direction decided — nature sounds vs. music vs. both, interaction feedback, source (royalty-free/custom/commissioned)
- [ ] **DESIGN-09**: JSON dialogue schema locked and documented in `data/dialogue/README.md` with format example — before Allie writes any content
- [ ] **DESIGN-10**: Sprite sheet format locked — frame size, grid layout, animation naming convention — before any art is created
- [ ] **DESIGN-11**: Allie's editor environment set up — VS Code with JSON validation extension installed and tested
- [ ] **DESIGN-12**: Phase 2+ roadmap created from resolved design decisions — build phases defined with requirements, success criteria, and phase ordering

## v2 Requirements

Deferred to Phase 2+ (defined after Phase 1). Preliminary shape from brainstorm:

- **GAME-01**: Lantern Clearing scene with atmosphere (fog particles, background, ambient audio)
- **GAME-02**: Fog clearing touch ritual with visual and haptic feedback
- **GAME-03**: Emotional check-in UI (4 states) stored in GameState, influences dialogue and quests
- **GAME-04**: Micro-quest display based on emotional state (16-20 quests minimum)
- **GAME-05**: Aetherling red panda sprite with idle animation
- **GAME-06**: Aetherling dialogue system with hand-written lines branching on emotional state
- **GAME-07**: 4 additional scene regions with unlock progression
- **GAME-08**: Reset / "begin again" mechanic with lantern relighting animation
- **GAME-09**: Full ambient audio pass — all SFX pre-loaded, per-type volume controls
- **GAME-10**: iOS App Store submission

## Out of Scope

| Feature | Reason |
|---------|--------|
| Multiplayer | Single-player only — no architectural benefit |
| Android export | Deferred post-MVP — same codebase, no cost to deferring |
| C# scripting | Experimental on mobile — documented launch/reflection crashes |
| Forward+ renderer | Crashes on AMD, zero 2D benefit |
| Daily streaks | Creates guilt — inverts the game's values |
| Push notifications | Converts sanctuary into obligation — dark pattern |
| Scores / performance metrics | Destroys the ritual feel |
| Monetization | This is a gift, not a product |
| Social features | This experience is private |
| Achievement / badge systems | Accumulation over presence — wrong philosophy |
| Dialogic plugin | Overkill for this dialogue volume, adds version lock burden |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| FOUND-01 | Phase 0 | Pending |
| FOUND-02 | Phase 0 | Pending |
| FOUND-03 | Phase 0 | Pending |
| FOUND-04 | Phase 0 | Pending |
| FOUND-05 | Phase 0 | Pending |
| FOUND-06 | Phase 0 | Pending |
| FOUND-07 | Phase 0 | Pending |
| FOUND-08 | Phase 0 | Pending |
| FOUND-09 | Phase 0 | Pending |
| FOUND-10 | Phase 0 | Pending |
| FOUND-11 | Phase 0 | Pending |
| FOUND-12 | Phase 0 | Pending |
| FOUND-13 | Phase 0 | Pending |
| DESIGN-01 | Phase 1 | Pending |
| DESIGN-02 | Phase 1 | Pending |
| DESIGN-03 | Phase 1 | Pending |
| DESIGN-04 | Phase 1 | Pending |
| DESIGN-05 | Phase 1 | Pending |
| DESIGN-06 | Phase 1 | Pending |
| DESIGN-07 | Phase 1 | Pending |
| DESIGN-08 | Phase 1 | Pending |
| DESIGN-09 | Phase 1 | Pending |
| DESIGN-10 | Phase 1 | Pending |
| DESIGN-11 | Phase 1 | Pending |
| DESIGN-12 | Phase 1 | Pending |

**Coverage:**
- v1 requirements: 25 total
- Mapped to phases: 25
- Unmapped: 0

---
*Requirements defined: 2026-04-10*
*Last updated: 2026-04-10 after initial definition*
