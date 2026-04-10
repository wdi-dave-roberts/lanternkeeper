# Lanternkeeper: Emberfall

## What This Is

A calm, ritual-based mobile companion game featuring a red panda named Aetherling. The player performs small tactile rituals (clearing fog, brushing leaves), checks in emotionally, and receives gentle micro-quests to support their creative work. Five ambient scene regions unlock over time. No scores, no streaks, no guilt. Built with Godot 4.6+ (GDScript), targeting iOS first.

This is a bonding/learning project between Dave and his daughter Allie (creative director + learning co-developer). The game is a gift for Garrett, a solo indie game dev working on Atlas.

## Core Value

Gentle, guilt-free creative companionship — the player feels cared for without pressure. The rituals and Aetherling's presence create a moment of calm that supports the player's real-world creative work.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Godot 4.6+ project with correct mobile settings (Compatibility renderer, 1080x1920 portrait, canvas_items stretch)
- [ ] 4 autoload singletons: GameState, SceneTransition, AudioManager, DialogueManager
- [ ] Touch input utility with tap/swipe/drag detection
- [ ] iOS build pipeline verified (exports, runs on device)
- [ ] Git LFS configured for binary assets
- [ ] Game design parameters resolved with Allie (session design, progression, art direction, sound)
- [ ] Phase 2+ roadmap defined from resolved design decisions

### Out of Scope

- Multiplayer — single-player only, no architectural benefit
- Android — deferred post-MVP, same codebase exports to both, no cost to deferring
- C# scripting — experimental on mobile, launch crashes on Android, reflection crashes on iOS
- Forward+ renderer — crashes on AMD hardware, shader stutter, zero benefit for 2D
- GPU particles — CPUParticles2D has lower fixed cost at low counts on mobile
- Monetization — this is a gift, not a product

## Context

**Team:** Dave (architecture, implementation, GDScript) + Allie (creative direction, dialogue writing, learning GDScript). Dave is an experienced developer learning game dev concepts. Allie is non-technical, learning through the project.

**Content workflow:** Allie edits JSON files in `data/` for dialogue and quest content. No GDScript knowledge needed for content changes. Dave handles all .gd and .tscn files.

**Learning resources:** Brackeys' Godot intro (YouTube), GDQuest tutorials, "GDScript in 10 minutes" cheat sheet for Allie.

**Target platform:** iOS first via Godot export. Android post-MVP with same codebase.

**Game genre:** Interactive ambient companion (Monument Valley's calm + Headspace's ritual structure).

**Timeline:** Flexible, no fixed target date.

## Constraints

- **Engine version**: Godot 4.6+ mandatory — mobile renderer improvements are transformative (16 to 70 FPS on budget hardware)
- **Language**: GDScript only — C# is experimental on mobile with launch crashes
- **Renderer**: Compatibility (OpenGL) — Forward+ crashes on AMD, zero 2D benefit
- **Display**: 1080x1920 portrait, canvas_items stretch, keep_height aspect
- **Mobile-first**: Safe areas, resolution scaling, touch input designed from start — not retrofitted
- **iOS testing**: Must test on real hardware early — things crash silently on iOS with no debug output
- **Scene upgrades**: Re-save scenes after Godot upgrades — 4.6 adds unique IDs, stale scenes cause messy diffs

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Godot 4.6+ / GDScript | Best 2D mobile engine, Python-like for Allie's learning, C# is broken on mobile | -- Pending |
| Compatibility renderer | Forward+ crashes on AMD, zero 2D benefit | -- Pending |
| CPUParticles2D | Lower fixed cost than GPU at low counts (<100/emitter), mobile-friendly | -- Pending |
| FileAccess.store_var() for state | Native type support, safe against code injection. ConfigFile for settings | -- Pending |
| JSON dialogue files | Allie can edit directly without GDScript knowledge | -- Pending |
| AnimatedSprite2D | Simpler mental model than AnimationPlayer for flipbook idles | -- Pending |
| 3 audio buses (Music/SFX/Ambient) | Clean separation, crossfade manager autoload | -- Pending |
| Git + LFS for binaries | .tres/.tscn are text (regular git), PNG/OGG/WAV/TTF via LFS | -- Pending |
| Phase 0-1 concrete, 2+ deferred | Allie's creative decisions in Phase 1 define what gets built | -- Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? -> Move to Out of Scope with reason
2. Requirements validated? -> Move to Validated with phase reference
3. New requirements emerged? -> Add to Active
4. Decisions to log? -> Add to Key Decisions
5. "What This Is" still accurate? -> Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-10 after initialization*
