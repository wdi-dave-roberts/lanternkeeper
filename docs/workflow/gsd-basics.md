# GSD Basics

GSD (Get Shit Done) is how we organize work on Lanternkeeper. It breaks the project into phases, tracks what's done and what's next, and keeps everything documented so neither of us loses context between sessions.

You don't need to understand all of GSD to use it. This page covers the commands you'll use most.

## How GSD Organizes Work

```
Project
└── Milestone (v1.0)
    ├── Phase 0: Technical Foundation (Dave)
    ├── Phase 1: Core Scenes (both)
    ├── Phase 2: Content & Polish (Allie + Dave)
    └── ...
```

- A **milestone** is a major version of the game
- A **phase** is a chunk of related work within a milestone
- A **plan** is a set of tasks within a phase
- Each phase has a goal, and GSD tracks whether that goal is met

The project roadmap and phase planning live in `.planning/` — Dave manages this. You can read it anytime to see where things stand.

## Checking Progress

### See where the project stands

> "/gsd-progress"

Shows the current phase, what's complete, what's next. Good way to orient yourself at the start of a session.

### See your pending tasks

> "/gsd-check-todos"

Lists any tasks or notes you've captured. Pick one to work on.

## Everyday Commands

These are the GSD commands you'll use most for content and creative work.

### Quick task — most of your work

> "/gsd-quick add fog forest dialogue for all four emotions"

Use this for straightforward work that doesn't need much planning. GSD will:

1. Create a quick plan for the task
2. Execute it (or help you execute it)
3. Commit the result
4. Track it as done

Good for: adding dialogue, editing content, updating docs, small creative tasks.

### Fast task — trivial changes

> "/gsd-fast fix typo in lantern_clearing.json calm dialogue"

Even lighter than quick. For tiny fixes that don't need a plan at all. Just does the thing and commits.

Good for: typo fixes, small wording changes, adding a single line.

### Capture an idea for later

> "/gsd-note Aetherling should have a special reaction when the player returns after a long absence"

Saves the idea without acting on it. You can review notes later and promote them to tasks when ready.

> "/gsd-note --list"

Shows all captured notes.

### Add a todo

> "/gsd-add-todo write energized dialogue for moss garden region"

Adds a task to the backlog. Unlike a note, a todo is something you intend to do — it shows up in `/gsd-check-todos`.

## Starting a Session

A good session start looks like this:

1. **Pull latest:** "Pull the latest changes"
2. **Check progress:** "/gsd-progress"
3. **See your tasks:** "/gsd-check-todos"
4. **Pick something and go:** "/gsd-quick [description of what you're doing]"

## When You're Done for the Day

> "/gsd-pause-work"

This saves your context so the next session (yours or Dave's) can pick up where you left off. It captures what you were working on, what's done, and what's still open.

## What the Commands Do Behind the Scenes

| Command | What GSD does | What gets committed |
|---|---|---|
| `/gsd-fast` | Executes immediately, commits | Your file changes |
| `/gsd-quick` | Creates a lightweight plan, executes, commits | Your file changes + a small plan doc |
| `/gsd-note` | Saves to notes file | Nothing (notes are local) |
| `/gsd-add-todo` | Adds to todo list | Todo file update |
| `/gsd-pause-work` | Saves session context | Context handoff file |
| `/gsd-progress` | Reads project state | Nothing (read-only) |
| `/gsd-check-todos` | Lists pending todos | Nothing (read-only) |

## Tips

- **Use `/gsd-quick` as your default.** It's the right level for most content work — gives you structure without overhead.
- **Commit messages matter.** GSD creates commit messages automatically, but you can always give it a specific message. Good messages help Dave understand what you did when he reviews history.
- **Notes are free.** If you have an idea while working on something else, capture it with `/gsd-note` and keep going. Don't lose the thought.
- **Check progress when you're lost.** `/gsd-progress` is your "where am I?" command. Use it liberally.
