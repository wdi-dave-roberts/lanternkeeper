# Roadmap: Lanternkeeper: Emberfall

## Overview

Two concrete phases build the foundation for this calm companion game. Phase 0 is Dave solo — no features Garrett would see, just verified technical bedrock: correct project settings, four autoload scaffolds, iOS pipeline proven on real hardware. Phase 1 is Dave and Allie together — every design and content contract locked before a single sprite is drawn or line of dialogue written. Phase 2+ is deliberately undefined; the final deliverable of Phase 1 is the Phase 2+ roadmap itself, built from the design decisions Allie and Dave make together.

## Phases

**Phase Numbering:**
- Integer phases (0, 1, 2, ...): Planned milestone work
- Decimal phases (1.1, 1.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 0: Technical Foundation** - Verified iOS build pipeline, correct project settings, four autoload scaffolds, Git LFS configured
- [ ] **Phase 1: Design Parameters** - All design and content contracts locked with Allie before any art or dialogue is created; Phase 2+ roadmap defined

> **Note:** Phase 2+ is intentionally undefined. The final step of Phase 1 (DESIGN-12) is to run `/gsd-add-phase` and define the build phases from Allie's resolved design decisions. No build phases are pre-planned because Allie's creative choices directly determine what gets built and in what order.

## Phase Details

### Phase 0: Technical Foundation
**Goal**: A blank Godot project runs on a physical iOS device with correct settings, all four autoloads scaffolded, and the full build pipeline verified — before any content work begins
**Depends on**: Nothing (first phase)
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-05, FOUND-06, FOUND-07, FOUND-08, FOUND-09, FOUND-10, FOUND-11, FOUND-12, FOUND-13
**Success Criteria** (what must be TRUE):
  1. The Godot project opens with Compatibility renderer, 1080x1920 portrait, `keep_width` stretch aspect — confirmed in project.godot
  2. All four autoloads (GameState, AudioManager, SceneTransition, DialogueManager) are registered in correct initialization order and each loads without error on a real iOS device
  3. A blank scene builds, signs, installs, and runs on a physical iOS device — no silent crashes, full pipeline verified end-to-end
  4. Git LFS is configured via .gitattributes for PNG, OGG, WAV, TTF before any binary asset is committed
  5. Allie's learning environment is prepared: Brackeys and GDQuest bookmarks, GDScript cheat sheet in hand
**Plans**: 4 plans

Plans:
- [x] 00-01-PLAN.md — GDScript autoloads, touch input, safe area container
- [x] 00-02-PLAN.md — Learning resources for Allie (docs site)
- [ ] 00-03-PLAN.md — Godot project creation, settings, test scene (human-driven)
- [ ] 00-04-PLAN.md — iOS pipeline verification (human-driven, Apple Developer enrollment)

### Phase 1: Design Parameters
**Goal**: Every design and content contract is locked with Allie — session design, art direction, sound direction, emotional states, dialogue schema, sprite format, quest design — so Phase 2+ build phases can be defined from real decisions, not assumptions
**Depends on**: Phase 0
**Requirements**: DESIGN-01, DESIGN-02, DESIGN-03, DESIGN-04, DESIGN-05, DESIGN-06, DESIGN-07, DESIGN-08, DESIGN-09, DESIGN-10, DESIGN-11, DESIGN-12
**Success Criteria** (what must be TRUE):
  1. Session design, progression rules, and reset mechanic are written down and agreed — Allie and Dave can each describe them the same way
  2. The four emotional state names are chosen, the art direction and sound direction are decided, and Aetherling's personality voice is documented
  3. The JSON dialogue schema is locked and `data/dialogue/README.md` exists with a format example — Allie can open it and write a valid line without asking Dave
  4. The sprite sheet format (frame size, grid, animation naming) is locked before any art is created
  5. The Phase 2+ roadmap exists in `.planning/ROADMAP.md` with build phases, requirements, and success criteria derived from the decisions made in this phase
**Plans**: TBD
**UI hint**: yes

## Progress

**Execution Order:**
Phases execute in numeric order: 0 → 1 → (2+ defined at end of Phase 1)

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 0. Technical Foundation | 0/4 | Planned | - |
| 1. Design Parameters | 0/TBD | Not started | - |
