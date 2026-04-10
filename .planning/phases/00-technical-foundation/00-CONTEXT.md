# Phase 0: Technical Foundation - Context

**Gathered:** 2026-04-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Verified Godot project setup with correct settings, four autoload scaffolds, iOS build pipeline proven on a physical device, Git LFS configured, and learning resources for Allie published to the docs site. No game content, no art, no dialogue — pure technical bedrock.

**Orientation folded in:** Godot fundamentals (scenes, nodes, scripts, signals, autoloads) are taught as part of Phase 0, not as a separate phase. Claude explains each concept in plain language before building it.

</domain>

<decisions>
## Implementation Decisions

### Autoload Scaffolding
- **D-01:** Godot orientation is folded into Phase 0 (no separate phase). Claude explains each concept (scenes, nodes, scripts, signals, autoloads) in plain language as it becomes relevant during the build. Install Godot is naturally the first step.
- **D-02:** Autoloads in Phase 0 should be functional stubs (not bare structure, not full implementation). Each service does its core job with placeholder content: GameState saves/loads, SceneTransition fades, AudioManager plays on correct bus, DialogueManager loads JSON. Enough to verify on iOS.

### iOS Pipeline
- **D-03:** Apple Developer Program enrollment is a prerequisite blocker — Dave does not currently have an active membership. Must sign up ($99/year) before iOS build verification can happen.
- **D-04:** The iOS test build should show something on screen — a simple scene with a colored background and "Lanternkeeper" label. Not just a blank screen that doesn't crash.
- **D-05:** iOS builds happen on Dave's MacBook or Mac Mini. Allie is PC only — she cannot do iOS builds.
- **D-06:** iOS minimum deployment target = 16.0, set manually in Xcode after every export (carried from research).

### Allie's Learning Resources
- **D-07:** Learning resources are markdown docs in the repo, served via the project docs site (https://wdi-dave-roberts.github.io/lanternkeeper/). Not browser bookmarks, not Google Docs.
- **D-08:** Phase 0-1 are Dave solo. Allie joins in Phase 1 for design decisions but Dave leads/drives those sessions. She is not hands-on in tools during Phase 0.
- **D-09:** Allie is 32, technically curious, exploring a potential career change into development. This project is a litmus test for her interest and aptitude. Learning resources should be curated and approachable, not overwhelming.

### Project Initialization
- **D-10:** Godot editor creates the project (generates project.godot). Do not hand-write project.godot — the internal format is version-specific and error-prone to author manually. After creation, verify and adjust the 5-6 key settings (renderer, resolution, stretch mode, orientation, touch emulation).

### Standing Rules (all phases)
- **D-11:** Docs site must be updated as work progresses — not as an afterthought. When platform differences exist (e.g., installing Godot), provide instructions for both Mac and PC.
- **D-12:** `keep_width` stretch aspect for portrait orientation (research correction from brainstorm).
- **D-13:** Git LFS must be committed before any binary asset enters history (.gitattributes already configured).

### Claude's Discretion
- Autoload initialization order (GameState first, then AudioManager, SceneTransition, DialogueManager — or adjust based on dependency analysis)
- Test scene structure for iOS verification (node hierarchy, exact layout)
- GDScript cheat sheet content and tutorial curation for Allie's learning docs

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project Configuration
- `CLAUDE.md` — Full validated tech stack, autoload architecture, project settings, display settings, what NOT to use
- `.planning/REQUIREMENTS.md` — FOUND-01 through FOUND-13 acceptance criteria for this phase
- `.planning/ROADMAP.md` — Phase 0 success criteria and phase dependencies

### Existing Configuration
- `.gitattributes` — Git LFS already configured for PNG, OGG, WAV, TTF, OTF, JPG, JPEG, PSD, TGA, MP3
- `.gitignore` — Godot 4 ignores (.godot/, export_presets.cfg, .mono/)

### External Documentation
- Godot 4.6 release notes: https://godotengine.org/releases/4.6/
- iOS export guide: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
- Multiple resolutions guide: https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
- Safe area handling: https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- Directory scaffold already created: `autoloads/`, `scenes/` (with 5 region subdirs), `shared/` (shaders, themes, ui), `assets/` (audio, fonts, sprites), `data/` (dialogue, quests)
- Git LFS tracking configured in `.gitattributes`
- MkDocs site configured (`mkdocs.yml`) with docs site at https://wdi-dave-roberts.github.io/lanternkeeper/

### Established Patterns
- No GDScript files exist yet — no patterns established
- No project.godot — Godot project has not been initialized

### Integration Points
- `autoloads/` directory exists (empty, has .gitkeep) — autoload scripts go here
- `docs/` directory exists — learning resources for Allie go here, served via MkDocs
- `scenes/` has 5 region subdirectories pre-created (lantern_clearing, fog_valley, observatory_balcony, warm_river, workshop_glade)

</code_context>

<specifics>
## Specific Ideas

- iOS test scene should display "Lanternkeeper" label on a colored background — not just a blank screen
- Allie's learning docs should be approachable for a 32-year-old exploring whether she likes development, not pitched at CS students
- Docs must cover both Mac and PC installation/setup where platforms differ

</specifics>

<deferred>
## Deferred Ideas

- ~~Phase 0.1: Orientation~~ — Folded into Phase 0. No separate phase needed.
- **Allie's PC development environment** — She's PC only. When she starts hands-on work (post Phase 1), her environment setup will need its own attention. Not relevant for Phase 0.

</deferred>

---

*Phase: 00-technical-foundation*
*Context gathered: 2026-04-10*
