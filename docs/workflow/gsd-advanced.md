# GSD Advanced

This page covers GSD's full workflow — the phase-level commands that Dave uses to orchestrate the project, and that you can use as you grow into more complex work.

You don't need this page to start contributing. The [GSD Basics](gsd-basics.md) commands handle everyday content work. Come back here when you're ready to take on bigger features or understand how the project is planned.

## The GSD Lifecycle

Every major piece of work follows this cycle:

```
Discuss → Plan → Execute → Verify
```

1. **Discuss** — figure out what to build and why, make key decisions
2. **Plan** — break it into tasks with clear acceptance criteria
3. **Execute** — do the work, commit each task
4. **Verify** — confirm the work meets the goal, not just that tasks were checked off

Dave runs this cycle for project phases. You can run it for your own features when they're complex enough to need structure.

## Phase-Level Commands

### Discuss a phase before planning

> "/gsd-discuss-phase 3"

Starts an interactive conversation about what Phase 3 should accomplish. GSD asks questions, captures decisions, and produces a context document that feeds into planning.

Use this when: you're about to start a creative feature (e.g., designing a new scene region) and want to think it through before diving in.

### Plan a phase

> "/gsd-plan-phase 3"

Takes the discussion output and creates detailed plans with tasks, file lists, acceptance criteria, and verification steps. This is where "what to build" becomes "how to build it."

Dave usually runs this, but you can run it for content-heavy phases where you're the primary contributor.

### Execute a phase

> "/gsd-execute-phase 3"

Runs all plans in a phase. GSD spawns agents to do the work, commits each task, and tracks progress. This is the heavy machinery — it handles parallel execution, checkpoints, and verification.

For content phases, this might mean GSD helps you write dialogue files, create quest definitions, or update docs — all organized and committed properly.

### Verify work

> "/gsd-verify-work 3"

Interactive verification after a phase completes. GSD walks through acceptance criteria and asks you to confirm things work as expected. This is where human judgment matters — automated checks can't tell you if dialogue feels right.

## Planning Your Own Feature

When you have a bigger creative task — say, designing all the dialogue and atmosphere for a new scene region — you can use the full GSD cycle:

```
/gsd-discuss-phase 5        ← "What should the fog forest feel like?"
/gsd-plan-phase 5           ← Breaks it into: dialogue, ambient text, quest hooks
/gsd-execute-phase 5        ← Creates the files, commits each piece
/gsd-verify-work 5          ← "Does this feel right? Read through the dialogue."
```

This gives your creative work the same structure Dave's code gets — documented decisions, tracked progress, verifiable outcomes.

## Other Useful Commands

### Resume work from a previous session

> "/gsd-resume-work"

Picks up where you (or Dave) left off. Loads context from the last session and tells you what's next.

### See project statistics

> "/gsd-stats"

Shows phase completion, plan counts, timeline, and velocity metrics. Good for getting a birds-eye view.

### Debug something that's broken

> "/gsd-debug"

Structured debugging workflow. If something in the game isn't working and you want to investigate (not just report to Dave), this walks you through diagnosing the issue systematically.

### Check project health

> "/gsd-health"

Checks the `.planning/` directory for issues — missing files, inconsistent state, broken references. Run this if GSD commands start giving weird errors.

## How Phases Connect to Your Work

A typical phase might look like this:

```
Phase 3: Fog Forest Region
├── Plan 01: Scene layout and background art (Dave)
├── Plan 02: Fog particle system (Dave)
├── Plan 03: Dialogue and atmosphere text (Allie)
├── Plan 04: Ambient audio integration (Dave)
└── Plan 05: Quest hooks for the region (Allie + Dave)
```

Plans within a phase can depend on each other — Plan 03 might need Plan 01 to be done first so you know the visual layout before writing atmospheric dialogue. GSD tracks these dependencies automatically.

## When to Use Advanced vs. Basics

| Situation | Use |
|---|---|
| Fix a dialogue typo | `/gsd-fast` (basics) |
| Add dialogue for an existing region | `/gsd-quick` (basics) |
| Design all content for a new region | `/gsd-discuss-phase` → `/gsd-plan-phase` (advanced) |
| Dave asked you to execute a planned phase | `/gsd-execute-phase` (advanced) |
| Something feels off and you want to investigate | `/gsd-debug` (advanced) |
| You want to see the big picture | `/gsd-progress` (basics) or `/gsd-stats` (advanced) |
