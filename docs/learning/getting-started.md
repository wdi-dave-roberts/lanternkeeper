# Getting Started

Two things to understand before diving in: how the project is organized (GSD), and how the game engine works (Godot).

## How We Build

This project uses a phased workflow called GSD to keep our work organized. Before touching any code or content, read [How We Build: GSD](gsd-guide.md) to understand the rhythm of discuss → plan → execute → verify.

## Godot — The Game Engine

A guide for getting set up and understanding what you're looking at.

## Install Godot

1. Go to [godotengine.org/download](https://godotengine.org/download)
2. Download **Godot 4.6+** (the standard version, not the .NET/C# version)
3. On Mac: drag to Applications. On Windows: unzip and run.
4. There's no installer — Godot is a single application.

## Open the Project

1. Launch Godot
2. Click "Import"
3. Navigate to the `lanternkeeper` folder and select `project.godot`
4. Click "Import & Edit"

## What You're Looking At

Godot's editor has four main areas:

- **Scene tree** (left) — A list of everything in the current scene, organized as a tree. Think of it like a family tree for game objects.
- **Inspector** (right) — Properties of whatever you have selected. Click something in the scene tree to see its details here.
- **Viewport** (center) — The visual editor. You can see and move things around.
- **Bottom panel** — Output log, debugger, audio bus editor. You'll mostly use this for error messages.

## The Scene Tree Mental Model

Everything in Godot is a **node** in a tree. Nodes can have children.

```
LanternClearing (the scene)
  ├── Background (a sprite)
  ├── Fog (a particle system)
  ├── Lantern (a sprite with a glow effect)
  ├── Aetherling (an animated sprite)
  └── UI (the dialogue box and buttons)
```

A scene is just a saved tree of nodes. You can edit it visually or in code.

## Running the Game

- Press **F5** to run the whole project
- Press **F6** to run just the current scene
- The game opens in a separate window

## Recommended Tutorials

Start here and work through in order:

1. **Brackeys' Godot intro tutorials** — [YouTube search: "Brackeys Godot"](https://www.youtube.com/results?search_query=brackeys+godot+4) — The community's #1 recommended starting point
2. **GDQuest's beginner tutorials** — [gdquest.com](https://www.gdquest.com/) — More in-depth, great for building real things
3. **Official Godot docs** — [docs.godotengine.org](https://docs.godotengine.org/en/stable/getting_started/introduction/index.html) — Reference when you need to look something up

## Your First Contribution

Before writing any code, you can start contributing content:

- **Dialogue**: Edit JSON files in `data/dialogue/` (see [Dialogue Guide](../content/dialogue-guide.md))
- **Quests**: Edit `data/quests/micro_quests.json` (see [Quest Guide](../content/quest-guide.md))

These are plain text files — no Godot knowledge required.
