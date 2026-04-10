# How We Build: The GSD Workflow

This project uses a workflow called **GSD (Git Shit Done)** to organize our work. This page explains what that means in plain terms — no prior technical knowledge needed.

## The Big Idea

Building a game has a lot of moving parts. GSD breaks the work into **phases** — small, focused chunks with a clear goal. Instead of a giant to-do list, you get a roadmap where each step builds on the last.

Think of it like building a house:

- Phase 0: Pour the foundation
- Phase 1: Frame the walls
- Phase 2: Install plumbing and electrical
- Phase 3: Finish the interior

You don't tile the bathroom before the walls are up. GSD keeps us building in the right order.

## How Phases Work

Every phase follows the same rhythm:

```
Discuss → Plan → Execute → Verify
```

1. **Discuss** — What are we building in this phase? What decisions need to be made? This is where your creative input lives.
2. **Plan** — Break the work into specific tasks. What files change? What gets created? This is the blueprint.
3. **Execute** — Do the work. Write the code, create the assets, edit the content. Each piece gets saved (committed) individually.
4. **Verify** — Did we actually build what we said we would? Check the result against the goal.

You don't have to memorize this. Dave runs the GSD commands. But knowing the rhythm helps you understand where we are at any point.

## Our Phases for Lanternkeeper

| Phase | What | Who Drives |
|-------|------|-----------|
| **Phase 0** | Technical foundation — install tools, set up the project, make architectural decisions | Dave |
| **Phase 1** | Game design parameters — session length, progression, art style, dialogue, sound | Allie |
| **Phase 2+** | Building the game — one phase per feature (the clearing, touch interactions, Aetherling, etc.) | Both |

Phase 1 is your phase. That's where you define what the game *is* — how long a session lasts, what unlocks each region, what Aetherling sounds like, what art style to use. Those decisions shape everything that comes after.

## Where Things Live

GSD creates a `.planning/` folder in the project. You don't need to edit anything in there, but here's what's inside:

| File | What It Is |
|------|-----------|
| `PROJECT.md` | The high-level project description — what we're building and why |
| `ROADMAP.md` | The list of all phases and their status |
| `phases/XX/PLAN.md` | The detailed plan for phase XX |
| `phases/XX/VERIFICATION.md` | The check that phase XX was completed correctly |

The roadmap is the best file to check if you want to see overall progress.

## What You'll See Day-to-Day

When we work together, a typical session looks like:

1. **Dave runs a GSD command** to start or continue a phase
2. **We discuss what needs to happen** — you make creative decisions, Dave translates to technical tasks
3. **Work happens** — code gets written, content gets created, things get committed to Git
4. **We check the result** — does the game do what we intended?

You'll also be working independently on content:

- Writing Aetherling's dialogue in JSON files (see [Dialogue Guide](../content/dialogue-guide.md))
- Writing micro-quests (see [Quest Guide](../content/quest-guide.md))
- Making art direction decisions
- Playtesting and giving feedback

That work feeds into the GSD phases but doesn't require running GSD commands yourself.

## Git: How Your Work Gets Saved

GSD uses **Git** to save work. Git is version control — it tracks every change so nothing is ever lost.

Key concepts:

- **Commit** — A saved snapshot of changes, with a message describing what changed. Like saving a document, but you can always go back to any previous save.
- **Push** — Send your saved changes to GitHub (the cloud) so the other person can see them.
- **Pull** — Download changes the other person pushed.

When you edit a dialogue JSON file:

1. Save the file
2. Dave (or you, when you're ready) commits and pushes it
3. The change is now part of the project permanently

GSD makes commits automatically as it works, so the history is clean and each change stands on its own.

## The Commands (Reference)

You don't need to run these yourself right away, but for reference, these are the GSD commands Dave uses:

| Command | What It Does |
|---------|-------------|
| `/gsd-progress` | Show where we are — current phase, what's done, what's next |
| `/gsd-discuss-phase` | Start the discussion for a phase — this is where design decisions happen |
| `/gsd-plan-phase` | Create the detailed plan for a phase |
| `/gsd-execute-phase` | Do the work in a phase |
| `/gsd-verify-work` | Check that a phase delivered what it promised |
| `/gsd-next` | Automatically move to the next step |

The most important one to know: **`/gsd-progress`** shows you the current state of the whole project at a glance.

## Why This Approach

We could just start coding and figure it out as we go. For a small project, that sometimes works. But we chose GSD because:

- **Neither of us has built a game before.** Structure helps when the territory is new.
- **We're working remotely.** Phases give us shared context even when we're not on a call.
- **Your input shapes the game.** GSD's discuss phase is specifically designed for the person with the vision (you) to define what gets built before coding starts.
- **Nothing gets lost.** Every decision, every piece of research, every plan is written down. If we pick this up after a week away, we can see exactly where we left off.
