# How We Work Together

Lanternkeeper is built by two people: Dave (code, architecture, build master) and Allie (creative direction, dialogue, content, learning developer). This section explains how we collaborate without stepping on each other's work.

## The Short Version

1. We both work on the `main` branch
2. We stay in our own zones (Allie: content and docs, Dave: code and scenes)
3. Before pushing work, always make sure you have the latest changes
4. Dave is the build master — he owns the project roadmap and fixes things if they break

## Roles

### Allie — Creative Director & Content Developer

**Your territory:**

| What | Where |
|------|-------|
| Dialogue | `data/dialogue/*.json` |
| Quests | `data/quests/*.json` |
| Art assets | `assets/sprites/` |
| Audio assets | `assets/audio/` |
| Documentation | `docs/` |

You own these areas. You can create, edit, and push files here freely. Dave won't be editing these files at the same time — they're yours.

**What you'll use:**

- **Claude Code** for all Git operations (committing, pushing, pulling)
- **Godot editor** to see your changes in the game
- **A text editor or Claude Code** to edit JSON dialogue files
- **GSD** to organize your work and track what you're doing

### Dave — Build Master & Lead Developer

**Your territory:**

| What | Where |
|------|-------|
| GDScript code | `autoloads/`, `shared/`, `scenes/**/*.gd` |
| Scene files | `scenes/**/*.tscn` |
| Project config | `project.godot`, `export_presets.cfg` |
| Planning | `.planning/` |
| Build pipeline | Godot export, iOS builds |

Dave also handles:

- Merging when zones occasionally overlap
- Fixing anything that breaks on `main`
- Running project-level GSD phases
- Resolving merge conflicts in code files

### Shared Zones

Some areas you'll both touch:

| What | Where | Rule |
|------|-------|------|
| Learning docs | `docs/learning/` | Either can edit, pull before push |
| MkDocs config | `mkdocs.yml` | Either can edit, pull before push |

In shared zones, the rule is simple: make sure you have the latest version before you push. If there's a conflict, the [conflict recovery guide](claude-code-cheatsheet.md#when-something-goes-wrong) explains what to do.

## The One Rule

**Always have the latest changes before you push your work.**

Before you tell Claude Code to commit and push, say:

> "Pull the latest changes first, then commit and push my work"

This prevents 99% of problems. If you forget, Git will tell you — it won't let you push if someone else pushed first. Just pull and try again.

## What Can Go Wrong (And Why Not to Worry)

| Scenario | Likelihood | Impact | Recovery |
|----------|-----------|--------|----------|
| You edit a dialogue file Dave is also editing | Very low (he doesn't edit dialogue) | Git conflict on push | Pull, resolve in your file, push again |
| You push a JSON file with a syntax error | Occasional | Dialogue won't load for that region | Fix the JSON, push again. Game doesn't crash — it just skips the bad file. |
| You accidentally edit a code file | Rare | Could break something | Tell Dave. He'll fix it with `git revert`. |
| You push a huge file not tracked by LFS | Very rare | Repo bloat | Tell Dave. He'll clean up Git history. |
| You and Dave push at the exact same time | Very rare | Push rejected | Pull and push again. No data lost. |

The worst case in any scenario is "tell Dave." Nothing you can do in your content zone will permanently break the project.

## How This Connects to GSD

GSD (Get Shit Done) is our project management workflow. It lives in the `.planning/` directory and tracks what needs to be built, what's done, and what's next.

- **Dave** runs the project-level GSD: phases, roadmaps, execution
- **Allie** uses GSD for her own work: quick tasks, content creation, notes

You share the same project state so you can both see where things stand. The [GSD Basics](gsd-basics.md) page covers the commands you'll use most.
