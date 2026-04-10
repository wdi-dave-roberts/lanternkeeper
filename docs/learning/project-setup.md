# Project Setup

How to create and configure the Lanternkeeper Godot project from scratch. Follow these steps exactly — the order matters.

## Prerequisites

- Git installed and configured
- The `lanternkeeper` repo cloned to your machine
- A code editor for JSON files (VS Code, or Godot's built-in editor)

## Step 1: Install Godot 4.6.2

Download the **standard** build from [godotengine.org/download](https://godotengine.org/download). Do NOT download the .NET/C# version — we use GDScript.

=== "Mac"

    1. Download the macOS universal build
    2. Unzip and drag **Godot.app** to `/Applications`
    3. First launch: right-click > Open (macOS will ask to verify since it's not from the App Store)

=== "PC"

    1. Download the Windows 64-bit build
    2. Unzip to a folder you'll remember (e.g., `C:\Godot\`)
    3. There is no installer — `Godot_v4.6.2-stable_win64.exe` is the entire application
    4. Optional: pin it to your taskbar or create a desktop shortcut

!!! note "No installer needed"
    Godot is a single file. No install wizard, no dependencies, no admin rights required. Just download, unzip, and run.

## Step 2: Create the Project

1. Open Godot
2. Click **New Project**
3. Fill in:
    - **Project Name:** `Lanternkeeper`
    - **Project Path:** point to your cloned repo folder

    === "Mac"

        `/Users/yourname/github/wdi-dave-roberts/lanternkeeper`

    === "PC"

        `C:\Users\yourname\github\wdi-dave-roberts\lanternkeeper`

    - **Renderer:** select **Compatibility** (OpenGL)

4. Click **Create & Edit**

Godot will generate a `project.godot` file in the repo root. This is the project configuration — it's tracked in Git.

## Step 3: Configure Project Settings

Open **Project > Project Settings** and set each value:

### Display

| Setting Path | Value |
|---|---|
| Display > Window > Size > Viewport Width | `1080` |
| Display > Window > Size > Viewport Height | `1920` |
| Display > Window > Stretch > Mode | `canvas_items` |
| Display > Window > Stretch > Aspect | `keep_width` |
| Display > Window > Handheld > Orientation | `portrait` |

!!! warning "keep_width, not keep_height"
    This is a portrait game. `keep_width` adds vertical space on taller phones (19:9, 21:9). `keep_height` is for landscape games — using it here would crop the sides on narrow screens.

### Input

| Setting Path | Value |
|---|---|
| Input Devices > Pointing > Emulate Touch From Mouse | `true` |

This lets you test touch interactions with your mouse during development. Without it, tap/swipe/drag gestures only work on a real phone.

!!! tip "Finding settings"
    Project Settings has a search bar at the top. Type part of the setting name (e.g., "touch") to jump straight to it instead of navigating the tree.

## Step 4: Create the SceneTransition Scene

SceneTransition needs a `.tscn` scene file (not just the `.gd` script) because it has a visual element — the fade-to-black overlay.

1. **Scene > New Scene**
2. Choose **Other Node** and select **CanvasLayer**
3. In the Inspector (right panel), set the **Layer** property to `128` (ensures the fade overlay draws on top of everything)
4. **Add a child node:** right-click the CanvasLayer > Add Child Node > **ColorRect**
5. Select the ColorRect, then in the toolbar above the viewport click **Layout > Full Rect** (this stretches it to fill the screen)
6. In the Inspector, set the ColorRect's **Color** to black (`#000000`)
7. Select the root CanvasLayer node, then in the Inspector click the script icon (or drag `autoloads/scene_transition.gd` onto it) to attach the script
8. **Save:** Ctrl+S (or Cmd+S on Mac) > save as `autoloads/scene_transition.tscn`

## Step 5: Register Autoloads

Open **Project > Project Settings > Autoload** tab.

For each autoload, click the folder icon to browse for the file, type the name, and click **Add**. Register them in this exact order (top to bottom):

| Name | Path |
|---|---|
| `GameState` | `res://autoloads/game_state.gd` |
| `AudioManager` | `res://autoloads/audio_manager.gd` |
| `SceneTransition` | `res://autoloads/scene_transition.tscn` |
| `DialogueManager` | `res://autoloads/dialogue_manager.gd` |

!!! note "SceneTransition uses the .tscn"
    Notice SceneTransition points to the `.tscn` file you just created, not the `.gd` file. The scene includes both the script and the ColorRect overlay. The other three autoloads are script-only — they create their nodes in code.

!!! note "Order matters"
    GameState loads first because other autoloads may read saved state. AudioManager loads second because SceneTransition may trigger audio. The order in the Autoload tab is the initialization order.

## Step 6: Create Audio Buses

1. Click the **Audio** tab at the bottom of the editor (next to Output, Debugger, etc.)
2. You'll see a default "Master" bus
3. Click **Add Bus** three times to create three new buses
4. Rename them (click the name at the top of each bus):
    - **Music**
    - **SFX**
    - **Ambient**
5. The layout saves automatically as `default_bus_layout.tres`

These buses let AudioManager control volume independently — you can mute sound effects without silencing the music.

## Step 7: Create the Test Scene

This is the first thing the game shows when it runs.

1. **Scene > New Scene**
2. Choose **Other Node** and select **MarginContainer**
3. Attach `shared/ui/safe_area_container.gd` as the script on the root MarginContainer (this handles iPhone notch/Dynamic Island margins)
4. Set the MarginContainer layout to **Full Rect**
5. Add a child: **ColorRect**
    - Set layout to **Full Rect**
    - Set color to a calm dark blue: `#1a1a2e`
6. Add a child to the MarginContainer (not the ColorRect): **Label**
    - Set **Text** to `Lanternkeeper`
    - Set layout to **Center**
    - In the Inspector under Theme Overrides > Font Sizes, set the font size to `48`
7. **Save** as `scenes/main/main.tscn` (create the `scenes/main/` folder if prompted)
8. Set as main scene: **Project > Project Settings > Application > Run > Main Scene** > browse to `res://scenes/main/main.tscn`

## Step 8: Test Run

Press **F5** (or the Play button in the top-right).

**What you should see:**

- A tall portrait window with a dark blue background
- "Lanternkeeper" centered on screen
- No red errors in the Output panel at the bottom

**If something goes wrong:**

| Symptom | Likely Cause |
|---|---|
| Window is landscape (wide) | Orientation not set to `portrait` in Project Settings |
| "Lanternkeeper" text is cut off on sides | Stretch aspect set to `keep_height` instead of `keep_width` |
| Red errors mentioning an autoload name | That autoload's path is wrong in Project Settings > Autoload |
| Game doesn't start at all | Main Scene not set in Project Settings > Application > Run |
| "Cannot open file" error | File path has a typo — check `res://` paths in autoload settings |

## Step 9: Verify Autoloads

After the test scene works, Dave will attach a verification script (`scenes/main/main.gd`) that prints confirmation to the Output panel. When you run the game, you should see:

```
=== Lanternkeeper Autoload Verification ===
GameState: return_count = 0 (incremented to 1)
DialogueManager line: [some calm dialogue]
AudioManager: ready, buses configured
SceneTransition: ready
=== All autoloads verified ===
```

If any line is missing or shows an error, that autoload needs attention.

## What Gets Committed

After setup, these new files should be in Git:

```
project.godot                      # Project configuration
autoloads/scene_transition.tscn    # SceneTransition scene
default_bus_layout.tres            # Audio bus layout
scenes/main/main.tscn             # Test scene
scenes/main/main.gd               # Autoload verification script
.godot/                            # Local cache (gitignored)
```

The `.godot/` folder is Godot's local cache — it's already in `.gitignore` and should never be committed.
