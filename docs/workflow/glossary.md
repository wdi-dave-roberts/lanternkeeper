# Glossary

Quick reference for technical terms you'll encounter working on Lanternkeeper. Don't memorize these — just come back when you see a word you don't recognize.

## Godot & Game Dev

**Autoload**
:   A script that Godot loads once at startup and keeps alive the entire time. Like a background service that any scene can talk to. Lanternkeeper has four: GameState, AudioManager, SceneTransition, DialogueManager. See [Autoloads Explained](../learning/autoloads-explained.md).

**Bus (Audio)**
:   A volume channel in Godot's audio system. Lanternkeeper has three: Music, SFX, and Ambient. Each bus can be adjusted independently — turn down music without muting sound effects.

**CanvasLayer**
:   A Godot node that draws on a specific layer, independent of the scene. SceneTransition uses one at layer 128 so the fade overlay always draws on top of everything.

**ColorRect**
:   A rectangle of solid color in Godot. Used for backgrounds, overlays, and placeholders.

**Compatibility Renderer**
:   Godot's OpenGL-based rendering mode. We use this instead of Forward+ (Vulkan) because it's more stable on mobile and doesn't crash on AMD hardware. No visual difference for 2D games.

**CPUParticles2D**
:   A particle system that runs on the CPU. Better than GPUParticles2D for small counts (<100 particles) on mobile devices. Used for fog, fireflies, and gentle effects.

**GDScript**
:   Godot's built-in programming language. Python-like syntax — if you can read Python, you can read GDScript. All Lanternkeeper code is GDScript.

**Inspector**
:   The panel on the right side of the Godot editor. Shows properties of whatever you have selected. Click a node in the scene tree to see its details here.

**Label**
:   A Godot node that displays text on screen.

**MarginContainer**
:   A Godot container node that adds padding around its children. We use one as the root of every scene with `safe_area_container.gd` attached to handle phone notches.

**Node**
:   The basic building block in Godot. Everything is a node — sprites, sounds, UI elements, containers. Nodes are organized in a tree (parent-child relationships).

**Portrait Mode**
:   The phone orientation where the screen is taller than it is wide. Lanternkeeper is always portrait — it's a one-hand companion app.

**Safe Area**
:   The part of the phone screen that isn't covered by the notch, Dynamic Island, or home indicator bar. Our SafeAreaContainer automatically adds margins so nothing gets hidden behind hardware.

**Scene (.tscn)**
:   A saved tree of nodes. Godot's fundamental building block. Each region in the game (lantern clearing, fog forest) is a scene. Scenes can contain other scenes.

**Scene Tree**
:   The panel on the left side of the Godot editor. Shows all nodes in the current scene organized as a hierarchy (parent > child).

**Signal**
:   How nodes communicate in Godot. A signal says "something happened" — like `transition_finished` or `line_ready`. Other nodes can listen for signals and respond. Named in past tense because they announce something that already occurred.

**Tween**
:   An animation tool built into Godot that smoothly changes a value over time. Used for fades, scale pulses, and audio crossfades. Simpler than AnimationPlayer for basic property transitions.

**Viewport**
:   The center area of the Godot editor where you see and manipulate your scene visually. Also refers to the game window size (1080x1920 for Lanternkeeper).

## Git & Version Control

**Commit**
:   A saved snapshot of your work at a point in time. Like saving a video game — you can always go back to any commit. Each commit has a message describing what changed and why.

**Conflict (Merge Conflict)**
:   When Git can't automatically combine two changes because two people edited the same part of the same file. Git marks the conflicting section and you (or Dave) choose which version to keep. See the [cheat sheet](claude-code-cheatsheet.md#when-something-goes-wrong) for how to handle these.

**Diff**
:   A comparison showing what changed between two versions of a file. Green lines were added, red lines were removed. Claude Code can show you diffs before you commit.

**Git**
:   A system for tracking changes to files. Keeps a complete history of every change anyone makes to the project. You can always undo, compare, or go back.

**GitHub**
:   A website that hosts Git repositories online. The shared copy of our project lives here. Like Google Drive for code — everyone pushes to and pulls from GitHub.

**Git LFS (Large File Storage)**
:   A Git extension that handles large binary files (images, audio, fonts) differently from text files. Configured automatically in our project — you don't need to do anything special.

**Pull**
:   Getting the latest changes from GitHub to your computer. "Pull before you start working" means get Dave's latest changes first so you're working on the current version.

**Push**
:   Sending your commits from your computer to GitHub. Makes your work visible to Dave. Always pull before you push.

**Repository (Repo)**
:   A folder containing the project's files and their complete Git history. The Lanternkeeper repo holds all game code, content, docs, and planning files.

**Staging**
:   Choosing which changed files to include in your next commit. Claude Code handles this for you — just tell it what to commit.

## GSD (Get Shit Done)

**GSD**
:   Our project management workflow. Breaks work into phases, tracks progress, documents decisions. Lives in the `.planning/` directory. See [GSD Basics](gsd-basics.md).

**Milestone**
:   A major version of the game. Lanternkeeper v1.0 is the first milestone. Contains multiple phases.

**Phase**
:   A chunk of related work within a milestone. "Phase 0: Technical Foundation" or "Phase 3: Fog Forest Region." Each phase has a goal, plans, and verification.

**Plan**
:   A set of tasks within a phase. Each plan has acceptance criteria — specific things that must be true when it's done.

**Roadmap**
:   The big-picture view of all phases in the current milestone. Shows what's done, what's in progress, and what's coming. View it with `/gsd-progress`.

**STATE.md**
:   The file that tracks where the project is right now — current phase, current plan, what happened last. GSD updates this automatically.

## Claude Code

**Claude Code (CC)**
:   The AI coding assistant you use for all Git operations, file editing, and GSD commands. You describe what you want in plain English, CC does the technical work.

**Slash Command**
:   A command that starts with `/` in Claude Code. Like `/gsd-quick` or `/gsd-progress`. These trigger specific workflows.

**CLAUDE.md**
:   A file in the repo root that gives Claude Code project-specific instructions. Contains technical decisions, conventions, and architecture notes. You don't need to edit this — Dave maintains it.

## Project-Specific

**Aetherling**
:   The red panda character in Lanternkeeper. The player's companion. Reacts to the player's emotional check-ins and the state of the world.

**Emotion Check-in**
:   When the player tells the game how they're feeling (calm, anxious, tired, energized). Aetherling and the dialogue respond to this choice.

**Region**
:   A distinct area in the game world — Lantern Clearing, Fog Forest, Moss Garden, etc. Each region is a Godot scene with its own dialogue, atmosphere, and rituals.

**Ritual**
:   A small tactile interaction the player performs — clearing fog with a swipe, brushing leaves with a drag, tapping the lantern to light it. The core gameplay loop.

**Zone (Workflow)**
:   Your area of ownership in the project. Allie's zone is content (`data/dialogue/`, `data/quests/`, `docs/`). Dave's zone is code (`autoloads/`, `scenes/`, `shared/`). See [How We Work Together](overview.md).
