# Phase 0: Technical Foundation - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-10
**Phase:** 0-technical-foundation
**Areas discussed:** Autoload scaffolding depth, iOS pipeline approach, Allie's learning setup, Project initialization method

---

## Autoload Scaffolding Depth

| Option | Description | Selected |
|--------|-------------|----------|
| Things work (functional stubs) | Each autoload works for its core job with placeholder content. Enough to verify on iOS and demo. | |
| Just runs without crashing (bare structure) | Blank screen, no interactions. Proves pipeline works. | |
| Everything finished (full implementation) | Production-complete autoloads. Risky before Phase 1 design decisions. | |

**User's choice:** User identified that the phase scope assumed Godot familiarity they don't have. Requested inserting a Phase 0.1: Orientation to learn Godot fundamentals first. After that discussion, functional stubs were implicitly agreed as the right depth — enough to verify on iOS without over-building before Allie's design decisions.

**Notes:** User has never created a game before. Didn't understand what "autoloads" meant until explained as "background services that are always running." The orientation phase addresses this knowledge gap.

---

## iOS Pipeline Approach

| Option | Description | Selected |
|--------|-------------|----------|
| Runs without crashing | Blank screen, proves pipeline works | |
| Shows something on screen | Colored background + "Lanternkeeper" label | ✓ |

**User's choice:** Shows something on screen

**Notes:** User does not have an Apple Developer Program membership — needs to sign up ($99/year) as a prerequisite. Has MacBook and Mac Mini for builds. Allie is PC only, cannot do iOS builds.

### Apple Developer Setup

| Option | Description | Selected |
|--------|-------------|----------|
| Active membership | Ready to sign and deploy | |
| Need to sign up | Must enroll before iOS verification | ✓ |
| Not sure | Unknown status | |

**User's choice:** Need to sign up

---

## Allie's Learning Setup

### Allie's Background

| Option | Description | Selected |
|--------|-------------|----------|
| Teen, comfortable with tech | Uses creative software, comfortable on screen | |
| Teen, less tech-oriented | Basic app usage | |
| Younger / needs more guidance | Step-by-step with pictures | |

**User's choice:** (Free text) 32 years old, more technical than average for her age group, wants to grow technically and learn development. Exploring a potential career change — using this project as a litmus test for interest and aptitude.

### Allie's Phase 0 Involvement

| Option | Description | Selected |
|--------|-------------|----------|
| Not involved yet | Phase 0 is Dave solo, resources are prep | |
| Learning alongside | Watching/working next to Dave | |
| Active participant | Installing Godot, following tutorials | |

**User's choice:** Phase 0-1 are all Dave. Allie joins Phase 1 for design decisions but Dave leads.

### When Allie Joins

| Option | Description | Selected |
|--------|-------------|----------|
| Phase 1, but I lead | Involved in design decisions, Dave driving | ✓ |
| After Phase 1 | Design decisions solo, Allie joins for content | |
| When she's ready | No fixed phase | |

**User's choice:** Phase 1, but I lead

### Learning Resource Format

| Option | Description | Selected |
|--------|-------------|----------|
| Markdown doc in the repo | LEARNING.md with curated links, accessible via GitHub | |
| Shared Google Doc | Living doc in Google Drive | |
| Just send links when ready | No formal prep artifact | |

**User's choice:** (Free text) Markdown docs in the repo, served via the docs site at https://wdi-dave-roberts.github.io/lanternkeeper/

---

## Project Initialization Method

| Option | Description | Selected |
|--------|-------------|----------|
| Godot editor creates it | Normal workflow, Godot generates project.godot, then verify settings | ✓ |
| Claude writes project.godot | Generate file directly, faster but riskier with internal formatting | |

**User's choice:** Initially asked for help deciding. After explanation of risks (internal format, version-specific quirks, still need to verify in Godot anyway), chose editor creation.

**Notes:** User needed the tradeoff explained because they're new to Godot and didn't know what project.godot was or why the creation method matters.

---

## Standing Rules (captured during discussion)

**User stated:** "As we proceed we have to remember to always update the docs site and when we do so and there are platform differences, e.g. installing Godot, we will need instructions for both mac and pc."

This applies to all phases, not just Phase 0.

## Claude's Discretion

- Autoload initialization order
- Test scene structure for iOS verification
- GDScript cheat sheet content and tutorial curation

## Deferred Ideas

- Phase 0.1: Orientation — walk through Godot fundamentals before building
- Allie's PC development environment — needed when she starts hands-on work post Phase 1
