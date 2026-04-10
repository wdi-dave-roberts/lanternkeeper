*[CanvasLayer]: A Godot node that draws on a separate rendering layer, independent of the main scene. Used for UI overlays, fade effects, and HUD elements that should stay on top.
*[ColorRect]: A simple Godot node that draws a rectangle of solid color. Used for backgrounds, overlays, and placeholders.
*[Inspector]: The panel on the right side of the Godot editor. Shows properties of whatever node you have selected.
*[Scene Tree]: The panel on the left side of the Godot editor. Shows all nodes in the current scene as a hierarchy.
*[MarginContainer]: A Godot container node that adds padding (margins) around its children. We use it as the root of every scene with safe area handling.
*[Full Rect]: A layout preset in Godot that stretches a node to fill its entire parent area — all four anchors set to cover the full space.
*[autoload]: A script or scene that Godot loads once at startup and keeps alive the entire game session. Globally accessible by name from any script.
*[GDScript]: Godot's built-in programming language. Python-like syntax — indentation matters, readable, no semicolons needed.
*[signal]: Godot's event system. A node emits a signal to announce something happened; other nodes connect to it to respond. Named in past tense (transition_finished, line_ready).
*[node]: The basic building block in Godot. Everything is a node — sprites, labels, sounds, containers. Organized in a tree hierarchy.
*[scene]: A saved tree of nodes that Godot can load and display. Each .tscn file is a scene. Regions, UI screens, and characters are all scenes.
*[tween]: A built-in Godot tool that smoothly animates a value from one number to another over time. Used for fades, movement, and transitions.
*[AudioStreamPlayer]: A Godot node that plays audio. One player per sound. AudioManager uses a pool of these for sound effects.
*[safe area]: The rectangle of phone screen not covered by the notch, Dynamic Island, or home bar. UI must stay inside this area to be visible.
*[viewport]: The game window. In Godot, the viewport defines the visible area and its resolution. Our base viewport is 1080x1920.
*[Git LFS]: Git Large File Storage — an extension that handles binary files (images, audio, fonts) efficiently so they don't bloat the repository.
*[commit]: A saved snapshot of your work in Git. Records which files changed, what changed, and why. Like a save point you can always return to.
*[GSD]: Get Shit Done — the project management workflow used on Lanternkeeper. Breaks work into phases, tracks progress, documents decisions.
