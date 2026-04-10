# Godot Reference

Quick-reference entries for Godot concepts you'll encounter while working on Lanternkeeper. Each entry explains what something is, why it matters, and where to learn more.

---

## File Types

### .gd — GDScript Files

A `.gd` file is a GDScript source file — the code that makes things happen. GDScript is Godot's built-in programming language. It looks a lot like Python: indentation matters, syntax is readable, and you don't need semicolons or curly braces.

**Example:** `autoloads/game_state.gd` contains the code that saves and loads player progress.

```gdscript
extends Node

const SAVE_PATH := "user://gamestate.dat"

func save_state() -> void:
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_var(_state, true)
```

A `.gd` file is always attached to a node — it defines what that node does. You can attach a script to a node in the Godot editor by selecting the node and clicking the script icon in the Inspector.

**In Lanternkeeper:** Dave writes all `.gd` files. Allie doesn't need to edit them, but reading them can help you understand how your dialogue JSON gets loaded and displayed.

**Learn more:**

- [GDScript basics (official docs)](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)
- [Our GDScript Basics page](../learning/gdscript-basics.md)

### .tscn — Scene Files

A `.tscn` file is a saved scene — a tree of nodes that Godot can load and display. "TSCN" stands for "Text Scene" because in Godot 4, scene files are stored as human-readable text (older versions used binary formats).

**Example:** `scenes/main/main.tscn` is the test scene with a dark blue background and the "Lanternkeeper" label.

Every `.tscn` file describes:

- Which nodes are in the scene and their parent-child relationships
- Each node's properties (position, color, size, etc.)
- Which scripts (`.gd` files) are attached to which nodes
- References to external resources (images, audio, fonts)

You create and edit `.tscn` files in the Godot editor — not in a text editor. When you save a scene in Godot (Ctrl+S / Cmd+S), it writes the `.tscn` file. Git can diff these files because they're text, which is why collaborative development works.

**In Lanternkeeper:** You'll create scenes in the Godot editor for new regions and UI layouts. Each region (Lantern Clearing, Fog Forest) is its own `.tscn` file.

**Learn more:**

- [Scenes and nodes (official docs)](https://docs.godotengine.org/en/stable/getting_started/step_by_step/nodes_and_scenes.html)

### .tres — Resource Files

A `.tres` file is a saved resource — data that nodes use but that isn't a scene. "TRES" stands for "Text Resource." Like `.tscn`, these are human-readable text in Godot 4.

**Examples:**

- `default_bus_layout.tres` — the audio bus layout (Music, SFX, Ambient)
- Theme files that define fonts, colors, and styles for UI elements
- Material files that define how something looks (shaders, colors)

You usually don't create `.tres` files directly. They get created when you configure something in the editor (like audio buses) and Godot saves it as a resource.

**Learn more:**

- [Resources (official docs)](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html)

### .godot/ — The Cache Directory

The `.godot/` folder is Godot's local cache. It contains imported versions of your assets (compressed textures, processed audio), shader cache, and editor state. 

**You never commit this folder.** It's in `.gitignore`. Every developer's machine regenerates it automatically when they open the project. If something seems broken and you can't figure out why, deleting the `.godot/` folder and reopening the project forces Godot to rebuild everything from scratch — a common fix for mysterious editor issues.

---

## Concepts

### Scene Transitions

A scene transition is the visual effect that plays when the game switches from one scene to another. Without a transition, changing scenes is an instant, jarring cut — one frame you're in the Lantern Clearing, the next frame you're in the Fog Forest with no warning.

Lanternkeeper uses a **fade-to-black** transition:

1. A black overlay fades in over 0.4 seconds (screen goes dark)
2. The old scene is unloaded and the new scene is loaded
3. The black overlay fades out over 0.4 seconds (new scene appears)

This lives in the `SceneTransition` autoload, which is why it needs a `.tscn` file — the black overlay (a `ColorRect` on a `CanvasLayer`) is a visual element that must exist in the scene tree.

**Why an autoload?** If the fade overlay lived inside each scene, it would disappear the moment the scene unloads — right in the middle of the fade. By putting it in an autoload (which never unloads), the overlay persists across scene changes and the fade looks smooth.

**Why layer 128?** The `CanvasLayer` is set to layer 128 so it draws on top of everything else. Normal scene content draws at lower layers. This guarantees the black overlay covers the entire screen during the fade, no matter what's in the scene underneath.

**How scenes use it:**

```gdscript
# Instead of this (ugly instant cut):
get_tree().change_scene_to_file("res://scenes/fog_forest/fog_forest.tscn")

# Scenes call this (smooth fade):
SceneTransition.transition_to("res://scenes/fog_forest/fog_forest.tscn")
```

**Learn more:**

- [Godot change scene tutorial (GDQuest)](https://www.gdquest.com/tutorial/godot/2d/scene-transition/)
- [Our Autoloads Explained page](../learning/autoloads-explained.md)

### Nodes and the Scene Tree

Everything in Godot is a **node**. A sprite is a node. A label is a node. A sound player is a node. A container that arranges other nodes is a node.

Nodes are organized in a **tree** — each node has one parent and can have many children. This hierarchy determines:

- **Drawing order** — children draw on top of parents (by default)
- **Transform inheritance** — if you move a parent, its children move with it
- **Lifecycle** — when a parent is removed from the tree, all its children are removed too

A **scene** is just a saved node tree. When you save a scene in the Godot editor, you're saving the tree structure and all the node properties to a `.tscn` file.

**In Lanternkeeper:** Each region (Lantern Clearing, Fog Forest) is a scene. The test scene's tree looks like:

```
MarginContainer (root — with safe_area_container.gd)
├── ColorRect (dark blue background)
└── Label ("Lanternkeeper")
```

**Learn more:**

- [Nodes and scenes (official docs)](https://docs.godotengine.org/en/stable/getting_started/step_by_step/nodes_and_scenes.html)
- [Scene tree (official docs)](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html)

### Autoloads

An autoload is a scene or script that Godot loads once at startup and keeps alive for the entire game session. They're globally accessible by name from any script in any scene.

Lanternkeeper has four autoloads — see [Autoloads Explained](../learning/autoloads-explained.md) for a detailed breakdown of each one.

**Key rules:**

- Autoloads initialize in the order they're listed in Project Settings > Autoload
- Never call another autoload from `_init()` — use `_ready()` instead (autoloads may not be ready yet during `_init()`)
- Autoloads don't appear in the scene tree editor — they're listed separately in Project Settings

**Learn more:**

- [Singletons / Autoload (official docs)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

### Signals

Signals are Godot's event system. A node emits a signal to announce that something happened, and other nodes can connect to that signal to respond.

**Analogy:** A signal is like a doorbell. The doorbell doesn't know or care who's listening. It just rings. Anyone who connected to it hears it and can decide what to do.

**In Lanternkeeper:**

- `SceneTransition` emits `transition_finished` after a fade completes
- `DialogueManager` emits `line_ready(text)` when it picks a dialogue line
- `TouchInput` emits `tapped(position)`, `swiped(direction)`, `dragged(delta)` for player gestures

**Convention:** Signal names use past tense because they announce something that already happened: `transition_finished`, not `transition_finish`.

```gdscript
# Defining a signal
signal line_ready(text: String)

# Emitting it (inside DialogueManager)
line_ready.emit("The clearing is quiet tonight.")

# Connecting to it (from another script)
DialogueManager.line_ready.connect(_on_dialogue_line)

func _on_dialogue_line(text: String) -> void:
    label.text = text
```

**The pattern:** "Call down, signal up." Parents call children's functions directly. Children emit signals that parents listen to. This keeps coupling loose — the child doesn't need to know who's listening.

**Learn more:**

- [Signals (official docs)](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html)
- [Our GDScript Basics page](../learning/gdscript-basics.md)

### Safe Areas

Modern phones have hardware that intrudes into the screen: the iPhone notch, Dynamic Island, camera cutouts on Android, and the home indicator bar at the bottom. The **safe area** is the rectangle of screen space that isn't covered by any of these elements.

If you place UI elements (text, buttons) outside the safe area, they'll be hidden behind the notch or unreachable under the home bar.

Lanternkeeper handles this with `SafeAreaContainer` — a script that reads the device's safe area from `DisplayServer.get_display_safe_area()` and applies margins to a `MarginContainer`. Every scene's root node uses this script so UI elements stay visible on any device.

**On desktop during development:** The safe area is the entire window (no notch, no cutout), so the margins are zero. You won't see any effect until you run on a real phone.

**Learn more:**

- [Multiple resolutions (official docs)](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html)
- [Safe area discussion (Godot forum)](https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971)
