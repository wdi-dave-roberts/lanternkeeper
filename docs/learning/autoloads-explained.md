# Autoloads Explained

## What's an Autoload?

An autoload is a script that Godot loads once when the game starts and keeps alive the entire time. Think of them like background services — they're always running, any scene can talk to them, and they don't disappear when you switch between screens.

Most things in Godot live inside scenes and disappear when you leave that scene. Autoloads are different. They start up with the game and stay alive until the game closes. Every scene can reach out to them at any time.

You'll see them used like this in the code:

```gdscript
GameState.get_value("return_count", 0)
AudioManager.play_music(intro_track)
```

No setup required — they're just there, always available.

## Why Lanternkeeper Uses Them

Without autoloads, every scene would need to manage its own music, its own save data, its own fade effect. That gets messy fast. A scene for the lantern area would need to know how to crossfade music. A scene for the fog ritual would need to know how to save progress. And they'd all have to share information by passing it back and forth.

Autoloads solve this by pulling cross-cutting concerns out of individual scenes. Each scene can focus on one thing — its visuals, its interactions — while the autoloads handle the shared infrastructure quietly in the background.

## The Four Autoloads

Lanternkeeper has exactly four autoloads. Here's what each one does.

---

### GameState

**File:** `autoloads/game_state.gd`

Remembers everything about the player's progress. Which scenes are unlocked, how many times they've returned, their last emotional check-in, their quest history. Saves all of this to a file on the device so progress survives closing the app.

When a scene needs to know something about the player's history, it asks GameState:

```gdscript
GameState.get_value("return_count", 0)
```

This asks GameState how many times the player has returned. The `0` is a fallback value — if no data exists yet (first time opening the game), you get `0` instead of an error.

---

### AudioManager

**File:** `autoloads/audio_manager.tscn` + `autoloads/audio_manager.gd`

Controls all sound: background music, sound effects, ambient atmosphere. Has three separate volume channels (called buses) so you can adjust music without affecting sound effects. Smoothly crossfades between songs instead of abruptly cutting.

The three buses:
- **Music** — background music that loops while you're in a region
- **SFX** — short sound effects for interactions (tapping, completing a ritual)
- **Ambient** — atmospheric loops like wind or forest sounds layered behind the music

When a scene changes, AudioManager handles the crossfade so the transition feels seamless instead of jarring.

---

### SceneTransition

**File:** `autoloads/scene_transition.tscn` + `autoloads/scene_transition.gd`

Handles the fade-to-black effect when moving between scenes. Without this, scene changes would be an ugly instant cut. The fade overlay lives in SceneTransition — not in each individual scene — so it's always available no matter what's on screen.

Scenes don't call `get_tree().change_scene_to_file()` directly. Instead, they ask SceneTransition to handle it:

```gdscript
SceneTransition.transition_to("res://scenes/lantern_clearing/lantern_clearing.tscn")
```

SceneTransition fades out, swaps the scene, and fades back in.

---

### DialogueManager

**File:** `autoloads/dialogue_manager.gd`

Loads Aetherling's dialogue from JSON files that you (Allie) edit directly. Picks lines based on the player's current emotion and region. Delivers them to whatever scene is currently showing Aetherling's dialogue box.

The dialogue itself lives in `data/dialogue/` as JSON files — no GDScript needed. DialogueManager reads those files, picks the right line for the moment, and emits it as a signal that the scene can display.

This is the autoload you'll interact with most indirectly — every time Aetherling says something, DialogueManager made it happen.

## How Scenes Talk to Autoloads

Calling an autoload from a scene script looks like a regular function call, just using the autoload's name:

```gdscript
# Ask GameState how many times the player has returned
var returns: int = GameState.get_value("return_count", 0)

# Play a music track
AudioManager.play_music(ambient_music)

# Go to a new scene with a fade
SceneTransition.transition_to("res://scenes/fog_forest/fog_forest.tscn")
```

The autoload name is available everywhere — you don't need to import anything or set up references. Godot makes them globally accessible by name.

## What You Don't Need to Know Yet

You don't need to understand the GDScript inside these files to work on Lanternkeeper. Your job is dialogue and creative direction. These autoloads are Dave's plumbing — they make your content work.

What you do need to know:

- **DialogueManager reads your JSON files.** When you add or change dialogue in `data/dialogue/`, DialogueManager picks it up. You don't need to touch any code.
- **Autoloads don't appear in the scene tree editor.** They're listed separately in Project Settings > Autoloads. If you're exploring the editor and can't find them in a scene, that's why.
- **If the game crashes on startup**, it's often because an autoload couldn't load. Dave handles those — you don't need to debug them.

When you're ready to learn more, the GDScript source for each autoload is in the `autoloads/` folder. But there's no rush — start with dialogue and let the architecture stay in the background.
